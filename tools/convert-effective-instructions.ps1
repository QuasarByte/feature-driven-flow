[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("directory-to-compact", "compact-to-directory")]
  [string] $Mode,

  [Parameter(Mandatory = $true)]
  [string] $InputPath,

  [Parameter(Mandatory = $true)]
  [string] $OutputPath,

  [Parameter(Mandatory = $false)]
  [ValidateSet("preserve", "reference", "portable", "hybrid")]
  [string] $ContentMode = "preserve",

  [Parameter(Mandatory = $false)]
  [bool] $IncludeEmbeddedSha256 = $true,

  [Parameter(Mandatory = $false)]
  [switch] $Force,

  [Parameter(Mandatory = $false)]
  [string] $RepoRoot
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $RepoRoot) {
  $RepoRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
}

$phaseOrder = @("scope", "explore", "clarify", "architect", "implement", "verify", "summarize")
$bundleSchemaPath = Join-Path $RepoRoot "schemas/fdf-effective-instructions-bundle.schema.json"
$compactSchemaPath = Join-Path $RepoRoot "schemas/fdf-effective-instructions-compact.schema.json"
$bundlePortableSchemaPath = Join-Path $RepoRoot "schemas/fdf-effective-instructions-bundle-portable.schema.json"
$compactPortableSchemaPath = Join-Path $RepoRoot "schemas/fdf-effective-instructions-compact-portable.schema.json"

function Resolve-PathFromRepo([string] $pathValue) {
  if ([System.IO.Path]::IsPathRooted($pathValue)) {
    return [System.IO.Path]::GetFullPath($pathValue)
  }
  return [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $pathValue))
}

function Ensure-PathWritable([string] $pathValue, [bool] $forceAllowed) {
  if (Test-Path $pathValue) {
    if (-not $forceAllowed) {
      throw "Path exists: $pathValue. Re-run with -Force to overwrite."
    }
    return
  }
  $parent = Split-Path -Parent $pathValue
  if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path $parent)) {
    New-Item -ItemType Directory -Path $parent | Out-Null
  }
}

function Read-Json([string] $pathValue) {
  if (-not (Test-Path $pathValue)) { throw "Missing file: $pathValue" }
  $raw = Get-Content $pathValue -Raw
  if ([string]::IsNullOrWhiteSpace($raw)) { throw "Empty JSON file: $pathValue" }
  return [ordered]@{
    Raw = $raw
    Object = (ConvertFrom-Json $raw -AsHashtable)
  }
}

function Validate-JsonTextAgainstSchema(
  [string] $jsonText,
  [string] $schemaPath,
  [string] $label
) {
  if (-not (Test-Path $schemaPath)) {
    throw "Schema file missing for ${label}: $schemaPath"
  }
  $ok = $false
  try {
    $ok = Test-Json -Json $jsonText -SchemaFile $schemaPath -ErrorAction Stop
  } catch {
    throw "$label failed schema validation: $($_.Exception.Message)"
  }
  if (-not $ok) {
    throw "$label failed schema validation."
  }
}

function Get-PhaseValue([hashtable] $map, [string] $phase, [string] $context) {
  if (-not $map.ContainsKey($phase)) {
    throw "$context missing required phase key '$phase'."
  }
  return [string]$map[$phase]
}

function Resolve-BundleSchemaPathById([string] $schemaId) {
  switch ($schemaId) {
    "fdf/effective-instructions-bundle.v1" { return $bundleSchemaPath }
    "fdf/effective-instructions-bundle-portable.v1" { return $bundlePortableSchemaPath }
    default { throw "Unsupported bundle schema id: $schemaId" }
  }
}

function Resolve-CompactSchemaPathById([string] $schemaId) {
  switch ($schemaId) {
    "fdf/effective-instructions-compact.v1" { return $compactSchemaPath }
    "fdf/effective-instructions-compact-portable.v1" { return $compactPortableSchemaPath }
    default { throw "Unsupported compact schema id: $schemaId" }
  }
}

function Validate-BundleRecord([hashtable] $record) {
  $schemaId = [string]$record.Object["schema"]
  if ([string]::IsNullOrWhiteSpace($schemaId)) {
    throw "Bundle manifest missing schema id."
  }
  $schemaPath = Resolve-BundleSchemaPathById $schemaId
  Validate-JsonTextAgainstSchema -jsonText $record.Raw -schemaPath $schemaPath -label "Directory bundle manifest"
  return $schemaId
}

function Validate-CompactRecord([hashtable] $record) {
  $schemaId = [string]$record.Object["schema"]
  if ([string]::IsNullOrWhiteSpace($schemaId)) {
    throw "Compact artifact missing schema id."
  }
  $schemaPath = Resolve-CompactSchemaPathById $schemaId
  Validate-JsonTextAgainstSchema -jsonText $record.Raw -schemaPath $schemaPath -label "Compact artifact"
  return $schemaId
}

function Get-Sha256Hex([string] $content) {
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
  $sha = [System.Security.Cryptography.SHA256]::Create()
  try {
    $hash = $sha.ComputeHash($bytes)
  } finally {
    $sha.Dispose()
  }
  return ([System.BitConverter]::ToString($hash).Replace("-", "").ToLowerInvariant())
}

function Convert-ProvenanceToEmbedded(
  [object[]] $provenanceFiles,
  [bool] $includeSha
) {
  $embedded = New-Object System.Collections.Generic.List[object]
  if ($null -eq $provenanceFiles) { return ,@() }

  foreach ($entry in $provenanceFiles) {
    if ($null -eq $entry) { continue }
    $path = [string]$entry.path
    if ([string]::IsNullOrWhiteSpace($path)) { continue }

    $resolved = Resolve-PathFromRepo $path
    if (-not (Test-Path $resolved)) {
      throw "Cannot embed missing provenance file: $path"
    }
    $content = Get-Content $resolved -Raw
    $obj = [ordered]@{
      kind = [string]$entry.kind
      path = $path
      content = $content
    }
    if (-not [string]::IsNullOrWhiteSpace([string]$entry.id)) {
      $obj["id"] = [string]$entry.id
    }
    if ($includeSha) {
      $obj["sha256"] = (Get-Sha256Hex $content)
    } elseif (-not [string]::IsNullOrWhiteSpace([string]$entry.sha256)) {
      $obj["sha256"] = [string]$entry.sha256
    }
    $embedded.Add($obj)
  }
  return ,($embedded.ToArray())
}

function Resolve-EffectiveOutputMode(
  [string] $requestedMode,
  [string] $inputSchemaId,
  [hashtable] $inputObject
) {
  if ($requestedMode -ne "preserve") {
    return $requestedMode
  }

  if ($inputSchemaId -like "*portable*") {
    $declared = [string]$inputObject["content_mode"]
    if ($declared -in @("portable", "hybrid")) {
      return $declared
    }
    return "portable"
  }
  return "reference"
}

if ($Mode -eq "directory-to-compact") {
  $inputDir = Resolve-PathFromRepo $InputPath
  if (-not (Test-Path $inputDir)) {
    throw "Input directory does not exist: $inputDir"
  }

  $manifestPath = Join-Path $inputDir "bundle.manifest.json"
  $manifestJson = Read-Json $manifestPath
  $inputSchemaId = Validate-BundleRecord -record $manifestJson
  $manifest = $manifestJson.Object

  $phaseFiles = $manifest["phase_files"]
  if ($null -eq $phaseFiles) { throw "Manifest missing phase_files." }

  $phaseInstructions = [ordered]@{}
  foreach ($phase in $phaseOrder) {
    $rel = Get-PhaseValue -map $phaseFiles -phase $phase -context "phase_files"
    $phasePath = [System.IO.Path]::GetFullPath((Join-Path $inputDir $rel))
    if (-not (Test-Path $phasePath)) {
      throw "Phase file not found for '$phase': $phasePath"
    }
    $phaseInstructions[$phase] = (Get-Content $phasePath -Raw)
  }

  $outputMode = Resolve-EffectiveOutputMode -requestedMode $ContentMode -inputSchemaId $inputSchemaId -inputObject $manifest

  $compact = [ordered]@{
    fdf_version = [string]$manifest["fdf_version"]
    created_at = [string]$manifest["created_at"]
    effective_matrix = $manifest["effective_matrix"]
    phase_instructions = $phaseInstructions
  }

  if ($outputMode -eq "reference") {
    $compact["schema"] = "fdf/effective-instructions-compact.v1"
    if ($manifest.ContainsKey("provenance_files")) {
      $compact["provenance_files"] = $manifest["provenance_files"]
    }
  } else {
    $compact["schema"] = "fdf/effective-instructions-compact-portable.v1"
    $compact["content_mode"] = $outputMode
    if ($manifest.ContainsKey("embedded_sources")) {
      $compact["embedded_sources"] = $manifest["embedded_sources"]
    } else {
      $compact["embedded_sources"] = Convert-ProvenanceToEmbedded -provenanceFiles $manifest["provenance_files"] -includeSha $IncludeEmbeddedSha256
    }
    if ($outputMode -eq "hybrid" -and $manifest.ContainsKey("provenance_files")) {
      $compact["provenance_files"] = $manifest["provenance_files"]
    }
  }
  if ($manifest.ContainsKey("custom_instructions")) {
    $compact["custom_instructions"] = $manifest["custom_instructions"]
  }
  if ($manifest.ContainsKey("notes")) {
    $compact["notes"] = [string]$manifest["notes"]
  }

  $compactText = $compact | ConvertTo-Json -Depth 40
  $compactSchemaOut = Resolve-CompactSchemaPathById ([string]$compact["schema"])
  Validate-JsonTextAgainstSchema -jsonText $compactText -schemaPath $compactSchemaOut -label "Compact artifact"

  $outFile = Resolve-PathFromRepo $OutputPath
  Ensure-PathWritable -pathValue $outFile -forceAllowed $Force
  [System.IO.File]::WriteAllText($outFile, $compactText + "`n", [System.Text.Encoding]::UTF8)
  Write-Host "Converted directory bundle to compact artifact: $outFile"
  exit 0
}

if ($Mode -eq "compact-to-directory") {
  $inFile = Resolve-PathFromRepo $InputPath
  $compactJson = Read-Json $inFile
  $inputSchemaId = Validate-CompactRecord -record $compactJson
  $compact = $compactJson.Object

  $phaseInstructions = $compact["phase_instructions"]
  if ($null -eq $phaseInstructions) { throw "Compact artifact missing phase_instructions." }

  $outDir = Resolve-PathFromRepo $OutputPath
  if (Test-Path $outDir) {
    $isEmpty = -not (Get-ChildItem -Path $outDir -Force | Select-Object -First 1)
    if (-not $isEmpty -and -not $Force) {
      throw "Output directory is not empty: $outDir. Re-run with -Force to overwrite."
    }
    if (-not $isEmpty -and $Force) {
      Get-ChildItem -Path $outDir -Force | Remove-Item -Recurse -Force
    }
  } else {
    New-Item -ItemType Directory -Path $outDir | Out-Null
  }

  $phasesDir = Join-Path $outDir "phases"
  if (-not (Test-Path $phasesDir)) {
    New-Item -ItemType Directory -Path $phasesDir | Out-Null
  }

  $phaseFiles = [ordered]@{}
  foreach ($phase in $phaseOrder) {
    $content = Get-PhaseValue -map $phaseInstructions -phase $phase -context "phase_instructions"
    $rel = "phases/$phase.md"
    $target = Join-Path $outDir "phases/$phase.md"
    [System.IO.File]::WriteAllText($target, $content, [System.Text.Encoding]::UTF8)
    $phaseFiles[$phase] = $rel
  }

  $outputMode = Resolve-EffectiveOutputMode -requestedMode $ContentMode -inputSchemaId $inputSchemaId -inputObject $compact

  $manifest = [ordered]@{
    fdf_version = [string]$compact["fdf_version"]
    created_at = [string]$compact["created_at"]
    effective_matrix = $compact["effective_matrix"]
    phase_files = $phaseFiles
  }

  if ($outputMode -eq "reference") {
    $manifest["schema"] = "fdf/effective-instructions-bundle.v1"
    if ($compact.ContainsKey("provenance_files")) {
      $manifest["provenance_files"] = $compact["provenance_files"]
    }
  } else {
    $manifest["schema"] = "fdf/effective-instructions-bundle-portable.v1"
    $manifest["content_mode"] = $outputMode
    if ($compact.ContainsKey("embedded_sources")) {
      $manifest["embedded_sources"] = $compact["embedded_sources"]
    } else {
      $manifest["embedded_sources"] = Convert-ProvenanceToEmbedded -provenanceFiles $compact["provenance_files"] -includeSha $IncludeEmbeddedSha256
    }
    if ($outputMode -eq "hybrid" -and $compact.ContainsKey("provenance_files")) {
      $manifest["provenance_files"] = $compact["provenance_files"]
    }
  }
  if ($compact.ContainsKey("custom_instructions")) {
    $manifest["custom_instructions"] = $compact["custom_instructions"]
  }
  if ($compact.ContainsKey("notes")) {
    $manifest["notes"] = [string]$compact["notes"]
  }

  $manifestText = $manifest | ConvertTo-Json -Depth 40
  $bundleSchemaOut = Resolve-BundleSchemaPathById ([string]$manifest["schema"])
  Validate-JsonTextAgainstSchema -jsonText $manifestText -schemaPath $bundleSchemaOut -label "Directory bundle manifest"

  $manifestOut = Join-Path $outDir "bundle.manifest.json"
  [System.IO.File]::WriteAllText($manifestOut, $manifestText + "`n", [System.Text.Encoding]::UTF8)
  Write-Host "Converted compact artifact to directory bundle: $outDir"
  exit 0
}

throw "Unknown mode: $Mode"
