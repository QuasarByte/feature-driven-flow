[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string] $RepoRoot
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $RepoRoot) {
  $RepoRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
}

$validPhases = @("scope", "explore", "clarify", "architect", "implement", "verify", "summarize")

function Get-RuleIdFromMarkdown([string] $content) {
  if ($content -match '(?ms)^##\s+id\s*(?:\r?\n)+\s*`([^`]+)`') { return $Matches[1].Trim() }
  return $null
}

function Get-AppliesToPhases([string] $content) {
  if ($content -match '(?ms)^##\s+applies_to_phases\s*(?:\r?\n)+\s*`([^`]+)`') {
    return ($Matches[1].Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" })
  }
  return @()
}

function Get-ProfileSection([string] $content, [string] $header) {
  $lines = $content -split "\r?\n"
  $start = -1
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match ("^\\s*###\\s+" + [Regex]::Escape($header) + "\\s*$")) {
      $start = $i + 1
      break
    }
  }
  if ($start -lt 0) { return "" }

  $buf = New-Object System.Collections.Generic.List[string]
  for ($j = $start; $j -lt $lines.Count; $j++) {
    if ($lines[$j] -match "^\\s*###\\s+" -or $lines[$j] -match "^\\s*##\\s+") { break }
    $buf.Add($lines[$j])
  }
  return ($buf -join "`n")
}

function Get-BacktickTokens([string] $text) {
  return ([Regex]::Matches($text, '`([^`]+)`') | ForEach-Object { $_.Groups[1].Value.Trim() } | Where-Object { $_ -ne "" })
}

function Parse-BoolLike([string] $value, [bool] $defaultValue) {
  if ([string]::IsNullOrWhiteSpace($value)) { return $defaultValue }
  $v = $value.Trim().ToLowerInvariant()
  if ($v -in @("true", "1", "yes", "on")) { return $true }
  if ($v -in @("false", "0", "no", "off")) { return $false }
  return $defaultValue
}

function Flatten-SettingsJson([object] $node, [string] $prefix, [hashtable] $map) {
  if ($null -eq $node) { return }

  if ($node -is [System.Collections.IDictionary]) {
    foreach ($k in $node.Keys) {
      $next = if ([string]::IsNullOrEmpty($prefix)) { [string]$k } else { "$prefix.$k" }
      Flatten-SettingsJson $node[$k] $next $map
    }
    return
  }

  if (($node -is [System.Collections.IEnumerable]) -and -not ($node -is [string])) {
    $items = @()
    foreach ($it in $node) {
      if ($it -is [System.Collections.IDictionary] -or (($it -is [System.Collections.IEnumerable]) -and -not ($it -is [string]))) {
        $items += (($it | ConvertTo-Json -Depth 10 -Compress))
      } else {
        $items += ([string]$it)
      }
    }
    $map[$prefix] = ($items -join ",")
    return
  }

  $map[$prefix] = [string]$node
}

function Parse-SettingsJson([string] $path) {
  $map = @{}
  if (-not (Test-Path $path)) { return $map }
  $raw = Get-Content $path -Raw
  if ([string]::IsNullOrWhiteSpace($raw)) { return $map }
  $obj = ConvertFrom-Json $raw -AsHashtable
  Flatten-SettingsJson $obj "" $map
  return $map
}

function Split-CommaList([string] $value) {
  if ([string]::IsNullOrWhiteSpace($value)) { return @() }
  return @($value.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" })
}

$problems = New-Object System.Collections.Generic.List[string]

function Validate-SettingsJsonFile(
  [string] $settingsPath,
  [string] $schemaPath,
  [string] $label,
  [bool] $required
) {
  if (-not (Test-Path $settingsPath)) {
    if ($required) { $problems.Add("$label settings file missing: $settingsPath") }
    return
  }

  if (-not (Test-Path $schemaPath)) {
    $problems.Add("Settings schema file missing: $schemaPath")
    return
  }

  try {
    $raw = Get-Content $settingsPath -Raw
  } catch {
    $problems.Add("$label settings file cannot be read: $settingsPath ($($_.Exception.Message))")
    return
  }

  if ([string]::IsNullOrWhiteSpace($raw)) {
    $problems.Add("$label settings file is empty: $settingsPath")
    return
  }

  try {
    $ok = Test-Json -Json $raw -SchemaFile $schemaPath -ErrorAction Stop
    if (-not $ok) {
      $problems.Add("$label settings file does not match schema: $settingsPath")
    }
  } catch {
    $problems.Add("$label settings schema validation error: $settingsPath ($($_.Exception.Message))")
  }
}

function Validate-JsonFileAgainstSchema(
  [string] $jsonPath,
  [string] $schemaPath,
  [string] $label,
  [bool] $required
) {
  if (-not (Test-Path $jsonPath)) {
    if ($required) { $problems.Add("$label JSON file missing: $jsonPath") }
    return
  }

  if (-not (Test-Path $schemaPath)) {
    $problems.Add("$label schema file missing: $schemaPath")
    return
  }

  try {
    $raw = Get-Content $jsonPath -Raw
  } catch {
    $problems.Add("$label JSON file cannot be read: $jsonPath ($($_.Exception.Message))")
    return
  }

  if ([string]::IsNullOrWhiteSpace($raw)) {
    $problems.Add("$label JSON file is empty: $jsonPath")
    return
  }

  try {
    $ok = Test-Json -Json $raw -SchemaFile $schemaPath -ErrorAction Stop
    if (-not $ok) {
      $problems.Add("$label JSON file does not match schema: $jsonPath")
    }
  } catch {
    $problems.Add("$label schema validation error: $jsonPath ($($_.Exception.Message))")
  }
}

$coreRuleDir = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/extensions/rules"
$coreProfileDir = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/extensions/profiles"
$globalSettingsJsonPath = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/settings.json"
$repoSettingsJsonPath = Join-Path $RepoRoot ".codex/feature-driven-flow/settings.json"
$settingsSchemaPath = Join-Path $RepoRoot "shared/fdf/schemas/fdf-settings.schema.json"
$effectiveMatrixSchemaPath = Join-Path $RepoRoot "shared/fdf/schemas/fdf-effective-matrix.schema.json"
$effectiveInstructionsBundleSchemaPath = Join-Path $RepoRoot "shared/fdf/schemas/fdf-effective-instructions-bundle.schema.json"
$effectiveInstructionsCompactSchemaPath = Join-Path $RepoRoot "shared/fdf/schemas/fdf-effective-instructions-compact.schema.json"
$effectiveInstructionsBundlePortableSchemaPath = Join-Path $RepoRoot "shared/fdf/schemas/fdf-effective-instructions-bundle-portable.schema.json"
$effectiveInstructionsCompactPortableSchemaPath = Join-Path $RepoRoot "shared/fdf/schemas/fdf-effective-instructions-compact-portable.schema.json"
$effectiveMatrixTemplatePath = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/templates/effective-rule-matrix.json"
$effectiveInstructionsBundleTemplatePath = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/templates/effective-instructions-bundle.manifest.json"
$effectiveInstructionsCompactTemplatePath = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/templates/effective-instructions-compact.json"
$effectiveInstructionsBundlePortableTemplatePath = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/templates/effective-instructions-bundle-portable.manifest.json"
$effectiveInstructionsCompactPortableTemplatePath = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/templates/effective-instructions-compact-portable.json"
$repoEffectiveMatrixPath = Join-Path $RepoRoot ".codex/feature-driven-flow/effective-rule-matrix.json"
$repoEffectiveInstructionsBundlePath = Join-Path $RepoRoot ".codex/feature-driven-flow/effective-instructions-bundle/bundle.manifest.json"
$repoEffectiveInstructionsCompactPath = Join-Path $RepoRoot ".codex/feature-driven-flow/effective-instructions-compact.json"
$repoEffectiveInstructionsBundlePortablePath = Join-Path $RepoRoot ".codex/feature-driven-flow/effective-instructions-bundle-portable/bundle.manifest.json"
$repoEffectiveInstructionsCompactPortablePath = Join-Path $RepoRoot ".codex/feature-driven-flow/effective-instructions-compact-portable.json"

Validate-SettingsJsonFile -settingsPath $globalSettingsJsonPath -schemaPath $settingsSchemaPath -label "Global" -required $true
Validate-SettingsJsonFile -settingsPath $repoSettingsJsonPath -schemaPath $settingsSchemaPath -label "Repository-local" -required $false
Validate-JsonFileAgainstSchema -jsonPath $effectiveMatrixTemplatePath -schemaPath $effectiveMatrixSchemaPath -label "Effective matrix template" -required $true
Validate-JsonFileAgainstSchema -jsonPath $repoEffectiveMatrixPath -schemaPath $effectiveMatrixSchemaPath -label "Repository-local effective matrix" -required $false
Validate-JsonFileAgainstSchema -jsonPath $effectiveInstructionsBundleTemplatePath -schemaPath $effectiveInstructionsBundleSchemaPath -label "Effective instructions bundle template" -required $true
Validate-JsonFileAgainstSchema -jsonPath $effectiveInstructionsCompactTemplatePath -schemaPath $effectiveInstructionsCompactSchemaPath -label "Effective instructions compact template" -required $true
Validate-JsonFileAgainstSchema -jsonPath $effectiveInstructionsBundlePortableTemplatePath -schemaPath $effectiveInstructionsBundlePortableSchemaPath -label "Effective instructions bundle portable template" -required $true
Validate-JsonFileAgainstSchema -jsonPath $effectiveInstructionsCompactPortableTemplatePath -schemaPath $effectiveInstructionsCompactPortableSchemaPath -label "Effective instructions compact portable template" -required $true
Validate-JsonFileAgainstSchema -jsonPath $repoEffectiveInstructionsBundlePath -schemaPath $effectiveInstructionsBundleSchemaPath -label "Repository-local effective instructions bundle" -required $false
Validate-JsonFileAgainstSchema -jsonPath $repoEffectiveInstructionsCompactPath -schemaPath $effectiveInstructionsCompactSchemaPath -label "Repository-local effective instructions compact" -required $false
Validate-JsonFileAgainstSchema -jsonPath $repoEffectiveInstructionsBundlePortablePath -schemaPath $effectiveInstructionsBundlePortableSchemaPath -label "Repository-local effective instructions bundle portable" -required $false
Validate-JsonFileAgainstSchema -jsonPath $repoEffectiveInstructionsCompactPortablePath -schemaPath $effectiveInstructionsCompactPortableSchemaPath -label "Repository-local effective instructions compact portable" -required $false

$globalSettings = @{}
$repoSettings = @{}
try {
  $globalSettings = Parse-SettingsJson $globalSettingsJsonPath
} catch {
  $problems.Add("Global settings JSON parse error: $globalSettingsJsonPath ($($_.Exception.Message))")
}
try {
  $repoSettings = Parse-SettingsJson $repoSettingsJsonPath
} catch {
  $problems.Add("Repository-local settings JSON parse error: $repoSettingsJsonPath ($($_.Exception.Message))")
}

$settings = @{}
foreach ($k in $globalSettings.Keys) { $settings[$k] = $globalSettings[$k] }
foreach ($k in $repoSettings.Keys) { $settings[$k] = $repoSettings[$k] }

$allowSharedPacks = Parse-BoolLike ($settings["packs.allow_shared_packs"]) $true
$allowLocalPacks = Parse-BoolLike ($settings["packs.allow_local_packs"]) $true
$enabledPackIds = Split-CommaList ($settings["packs.enabled"])

$sharedPacksRel = if ($settings.ContainsKey("packs.shared_dir") -and -not [string]::IsNullOrWhiteSpace($settings["packs.shared_dir"])) { $settings["packs.shared_dir"] } else { "shared/fdf/skills/feature-driven-flow/packs" }
$localPacksRel = if ($settings.ContainsKey("packs.local_dir") -and -not [string]::IsNullOrWhiteSpace($settings["packs.local_dir"])) { $settings["packs.local_dir"] } else { ".codex/feature-driven-flow/packs" }

$packsDir = Join-Path $RepoRoot $sharedPacksRel
$localPacksDir = Join-Path $RepoRoot $localPacksRel

$ruleFiles = @(Get-ChildItem -Path $coreRuleDir -Filter *.md -File)
$profileFiles = @()
if (Test-Path $coreProfileDir) { $profileFiles = @(Get-ChildItem -Path $coreProfileDir -Filter *.md -File) }

# Validate uniqueness across all discovered packs, independent of packs.enabled.
$packDirsForValidation = @()
$seenPackDirs = @{}
foreach ($root in @($packsDir, $localPacksDir)) {
  if (-not (Test-Path $root)) { continue }
  foreach ($d in (Get-ChildItem -Path $root -Directory)) {
    if ($seenPackDirs.ContainsKey($d.FullName)) { continue }
    $seenPackDirs[$d.FullName] = $true
    $packDirsForValidation += $d
  }
}
foreach ($d in $packDirsForValidation) {
  $rd = Join-Path $d.FullName "extensions/rules"
  if (Test-Path $rd) { $ruleFiles += @(Get-ChildItem -Path $rd -Filter *.md -File) }
  $pd = Join-Path $d.FullName "extensions/profiles"
  if (Test-Path $pd) { $profileFiles += @(Get-ChildItem -Path $pd -Filter *.md -File) }
}

# Validate enabled pack ids resolve to at least one allowed source (shared/local)
if ($enabledPackIds.Count -gt 0) {
  foreach ($packId in $enabledPackIds) {
    $sharedExists = $false
    $localExists = $false
    if ($allowSharedPacks) { $sharedExists = Test-Path (Join-Path $packsDir $packId) }
    if ($allowLocalPacks) { $localExists = Test-Path (Join-Path $localPacksDir $packId) }
    if (-not ($sharedExists -or $localExists)) {
      $problems.Add("Enabled pack '$packId' not found in allowed pack directories.")
    }
  }
}

# Load and validate rules
$rulesById = @{}
foreach ($f in $ruleFiles) {
  $content = Get-Content $f.FullName -Raw
  $id = Get-RuleIdFromMarkdown $content
  if (-not $id) {
    $problems.Add("Rule missing ## id: $($f.FullName)")
    continue
  }
  if ($rulesById.ContainsKey($id)) {
    $problems.Add("Duplicate rule id '$id': $($f.FullName) and $($rulesById[$id])")
    continue
  }
  $rulesById[$id] = $f.FullName

  $phases = Get-AppliesToPhases $content
  if ($phases.Count -eq 0) {
    $problems.Add("Rule '$id' missing/empty applies_to_phases: $($f.FullName)")
    continue
  }
  foreach ($p in $phases) {
    if ($validPhases -notcontains $p) {
      $problems.Add("Rule '$id' has invalid phase '$p' in applies_to_phases: $($f.FullName)")
    }
  }
}

# Load and validate profiles (lightweight)
$profilesById = @{}
foreach ($f in $profileFiles) {
  $content = Get-Content $f.FullName -Raw
  $id = Get-RuleIdFromMarkdown $content
  if (-not $id) {
    $problems.Add("Profile missing ## id: $($f.FullName)")
    continue
  }
  if ($profilesById.ContainsKey($id)) {
    $problems.Add("Duplicate profile id '$id': $($f.FullName) and $($profilesById[$id])")
    continue
  }
  $profilesById[$id] = $f.FullName

  $alwaysRules = New-Object System.Collections.Generic.List[string]
  $lines = $content -split "\r?\n"
  $inAlways = $false
  foreach ($line in $lines) {
    if ($line -match '^\s*###\s+always\b') { $inAlways = $true; continue }
    if (-not $inAlways) { continue }
    if ($line -match '^\s*###\s+' -or $line -match '^\s*##\s+') { break }
    foreach ($m in [Regex]::Matches($line, '`([^`]+)`')) {
      $tok = $m.Groups[1].Value.Trim()
      if ($tok) { $alwaysRules.Add($tok) }
    }
  }
  if ($alwaysRules.Count -eq 0) {
    $problems.Add("Profile '$id' has empty rule_sets.always: $($f.FullName)")
    continue
  }
  foreach ($rid in $alwaysRules) {
    if (-not $rulesById.ContainsKey($rid)) {
      $problems.Add("Profile '$id' references unknown rule id '$rid': $($f.FullName)")
    }
  }
}

if ($problems.Count -gt 0) {
  Write-Host "FDF asset validation failed:"
  $problems | ForEach-Object { Write-Host " - $_" }
  exit 1
}

Write-Host "FDF asset validation passed."
