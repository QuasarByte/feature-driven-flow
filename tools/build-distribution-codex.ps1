[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string] $Version,

  [Parameter(Mandatory = $false)]
  [string] $RepoRoot,

  [Parameter(Mandatory = $false)]
  [string] $OutDir,

  [Parameter(Mandatory = $false)]
  [switch] $Force
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $RepoRoot) {
  $RepoRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
}
if (-not $OutDir) {
  $OutDir = Join-Path $RepoRoot "distrib/feature-driven-flow-codex"
}

$codexDir = Join-Path $RepoRoot "codex"
$sharedDir = Join-Path $RepoRoot "shared/fdf"
$versionFile = Join-Path $RepoRoot "version.json"
$distReadme = Join-Path $codexDir "README.md"
$licenseFile = Join-Path $codexDir "LICENSE"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-Utf8LfFile {
  param(
    [Parameter(Mandatory = $true)]
    [string] $Path,

    [Parameter(Mandatory = $true)]
    [string] $Content
  )

  [System.IO.File]::WriteAllText($Path, $Content.Replace("`r`n", "`n"), $utf8NoBom)
}

function Update-DistributionManifestPaths {
  param(
    [Parameter(Mandatory = $true)]
    [string] $Path
  )

  $json = Get-Content -Path $Path -Raw | ConvertFrom-Json -AsHashtable

  function Rewrite-Value {
    param([object] $Value)

    if ($Value -is [string]) {
      if ($Value.StartsWith('shared/fdf/')) {
        return ('fdf/' + $Value.Substring('shared/fdf/'.Length))
      }
      return $Value
    }

    if ($Value -is [System.Collections.IDictionary]) {
      foreach ($key in @($Value.Keys)) {
        $Value[$key] = Rewrite-Value $Value[$key]
      }
      return $Value
    }

    if ($Value -is [System.Collections.IList]) {
      for ($i = 0; $i -lt $Value.Count; $i++) {
        $Value[$i] = Rewrite-Value $Value[$i]
      }
      return $Value
    }

    return $Value
  }

  $json = Rewrite-Value $json
  Write-Utf8LfFile -Path $Path -Content (($json | ConvertTo-Json -Depth 20) + "`n")
}

# ---------------------------------------------------------------------------
# Validate source
# ---------------------------------------------------------------------------
$requiredCodexSources = @(
  "skills/feature-driven-flow/SKILL.md",
  "skills/feature-driven-flow/behavior.md",
  "skills/fdf-code-explorer/SKILL.md",
  "skills/fdf-implementation-planner/SKILL.md",
  "skills/fdf-change-auditor/SKILL.md",
  "prompts/fdf-start.md",
  "README.md",
  "LICENSE"
)
$requiredSharedSources = @(
  "schemas",
  "skills/feature-driven-flow",
  "scripts/convert-effective-instructions.ps1"
)

$missing = @()
foreach ($rel in $requiredCodexSources) {
  if (-not (Test-Path (Join-Path $codexDir $rel))) {
    $missing += "codex/$rel"
  }
}
foreach ($rel in $requiredSharedSources) {
  if (-not (Test-Path (Join-Path $sharedDir $rel))) {
    $missing += "shared/fdf/$rel"
  }
}
if (-not (Test-Path $versionFile)) {
  $missing += "version.json"
}
if ($missing.Count -gt 0) {
  Write-Error "Source validation failed. Missing from codex/ + shared assets:`n$($missing -join "`n")"
  exit 1
}

# ---------------------------------------------------------------------------
# Prepare output directory
# ---------------------------------------------------------------------------
if (Test-Path $OutDir) {
  if (-not $Force) {
    Write-Error "Output directory already exists: $OutDir`nRe-run with -Force to overwrite."
    exit 1
  }
  Get-ChildItem -Path $OutDir -Force | Remove-Item -Recurse -Force
} else {
  New-Item -ItemType Directory -Path $OutDir | Out-Null
}

# ---------------------------------------------------------------------------
# Copy distribution components
# ---------------------------------------------------------------------------
$copyMap = @(
  @{ Source = Join-Path $codexDir "skills"; Destination = Join-Path $OutDir "skills" },
  @{ Source = Join-Path $codexDir "prompts"; Destination = Join-Path $OutDir "prompts" },
  @{ Source = $sharedDir; Destination = Join-Path $OutDir "fdf" }
)

foreach ($entry in $copyMap) {
  if (-not (Test-Path $entry.Source)) { continue }
  Copy-Item -Recurse -Force $entry.Source $entry.Destination
}

Copy-Item -Force $distReadme (Join-Path $OutDir "README.md")
Copy-Item -Force $licenseFile (Join-Path $OutDir "LICENSE")
Copy-Item -Force $versionFile (Join-Path $OutDir "version.json")

# ---------------------------------------------------------------------------
# Patch packaged runtime paths
# ---------------------------------------------------------------------------
$settingsPath = Join-Path $OutDir "fdf/skills/feature-driven-flow/settings.json"
$settings = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json -AsHashtable
$settings['packs']['shared_dir'] = 'fdf/skills/feature-driven-flow/packs'
Write-Utf8LfFile -Path $settingsPath -Content (($settings | ConvertTo-Json -Depth 20) + "`n")

$manifestPaths = @(
  (Join-Path $OutDir "fdf/skills/feature-driven-flow/manifest.json"),
  (Join-Path $OutDir "fdf/skills/feature-driven-flow/extensions/manifest.json")
)
$manifestPaths += @(Get-ChildItem -Path (Join-Path $OutDir 'fdf/skills/feature-driven-flow/packs') -Filter manifest.json -Recurse -File | Select-Object -ExpandProperty FullName)
foreach ($manifestPath in $manifestPaths) {
  Update-DistributionManifestPaths -Path $manifestPath
}

$readmePath = Join-Path $OutDir 'README.md'
$readme = Get-Content -Path $readmePath -Raw

# ---------------------------------------------------------------------------
# Patch version in version.json and README (optional)
# ---------------------------------------------------------------------------
$versionJsonPath = Join-Path $OutDir "version.json"
$versionJson = Get-Content $versionJsonPath -Raw | ConvertFrom-Json -AsHashtable

if ($Version) {
  $versionJson['version'] = $Version
  Write-Utf8LfFile -Path $versionJsonPath -Content (($versionJson | ConvertTo-Json -Depth 10) + "`n")
  $readme = [regex]::Replace($readme, 'Version: `[^`]+`', 'Version: `' + $Version + '`')
  Write-Host "Patched version: $Version"
} else {
  $Version = [string]$versionJson['version']
}

Write-Utf8LfFile -Path $readmePath -Content $readme

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
$fileCount = (Get-ChildItem -Recurse -File $OutDir).Count

Write-Host ""
Write-Host "Codex distribution build complete"
Write-Host "  Package  : feature-driven-flow-codex v$Version"
Write-Host "  Output   : $OutDir"
Write-Host "  Files    : $fileCount"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Inspect: ls '$OutDir'"
Write-Host "  2. Install into CODEX_HOME/project root:"
Write-Host "       Copy '$OutDir/skills/*' -> '`$CODEX_HOME/skills/'"
Write-Host "       Copy '$OutDir/prompts/*.md' -> '`$CODEX_HOME/prompts/'"
Write-Host "       Copy '$OutDir/fdf' -> '<project-root>/fdf'"
