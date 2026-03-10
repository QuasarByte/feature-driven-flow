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

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $RepoRoot) {
  $RepoRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
}
if (-not $OutDir) {
  $OutDir = Join-Path $RepoRoot "distrib/feature-driven-flow-claude"
}

$claudeDir = Join-Path $RepoRoot "claude-code"
$sharedDir = Join-Path $RepoRoot "shared/fdf"
$marketplaceJsonSource = Join-Path $claudeDir ".claude-plugin/marketplace.json"
$pluginSourceDir = Join-Path $claudeDir "plugins/feature-driven-flow"
$pluginOutDir = Join-Path $OutDir "plugins/feature-driven-flow"

$requiredClaudeSources = @(
  ".claude-plugin/marketplace.json",
  "LICENSE",
  "README.md",
  "plugins/feature-driven-flow/.claude-plugin/plugin.json",
  "plugins/feature-driven-flow/skills/feature-driven-flow/SKILL.md",
  "plugins/feature-driven-flow/skills/feature-driven-flow/behavior.md",
  "plugins/feature-driven-flow/skills/fdf-code-explorer/SKILL.md",
  "plugins/feature-driven-flow/skills/fdf-implementation-planner/SKILL.md",
  "plugins/feature-driven-flow/skills/fdf-change-auditor/SKILL.md",
  "plugins/feature-driven-flow/commands",
  "plugins/feature-driven-flow/README.md"
)
$requiredSharedSources = @(
  "schemas",
  "skills/feature-driven-flow",
  "scripts/convert-effective-instructions.ps1"
)

$missing = @()
foreach ($rel in $requiredClaudeSources) {
  if (-not (Test-Path (Join-Path $claudeDir $rel))) { $missing += "claude-code/$rel" }
}
foreach ($rel in $requiredSharedSources) {
  if (-not (Test-Path (Join-Path $sharedDir $rel))) { $missing += "shared/fdf/$rel" }
}
if ($missing.Count -gt 0) {
  Write-Error "Source validation failed.`n$($missing -join "`n")"
  exit 1
}

if (Test-Path $OutDir) {
  if (-not $Force) {
    Write-Error "Output directory already exists: $OutDir`nRe-run with -Force to overwrite."
    exit 1
  }
  Get-ChildItem -Path $OutDir -Force | Remove-Item -Recurse -Force
} else {
  New-Item -ItemType Directory -Path $OutDir | Out-Null
}

New-Item -ItemType Directory -Path (Join-Path $OutDir '.claude-plugin') -Force | Out-Null
New-Item -ItemType Directory -Path $pluginOutDir -Force | Out-Null

Copy-Item -Force $marketplaceJsonSource (Join-Path $OutDir '.claude-plugin/marketplace.json')
Copy-Item -Force (Join-Path $claudeDir 'LICENSE') (Join-Path $OutDir 'LICENSE')
Copy-Item -Force (Join-Path $claudeDir 'README.md') (Join-Path $OutDir 'README.md')
Copy-Item -Recurse -Force (Join-Path $pluginSourceDir '.claude-plugin') (Join-Path $pluginOutDir '.claude-plugin')
Copy-Item -Recurse -Force (Join-Path $pluginSourceDir 'skills') (Join-Path $pluginOutDir 'skills')
Copy-Item -Recurse -Force (Join-Path $pluginSourceDir 'commands') (Join-Path $pluginOutDir 'commands')
Copy-Item -Force (Join-Path $pluginSourceDir 'README.md') (Join-Path $pluginOutDir 'README.md')
Copy-Item -Recurse -Force $sharedDir (Join-Path $pluginOutDir 'fdf')

$pluginJsonPath = Join-Path $pluginOutDir '.claude-plugin/plugin.json'
$pluginJson = Get-Content $pluginJsonPath -Raw | ConvertFrom-Json -AsHashtable
$marketplaceJsonPath = Join-Path $OutDir '.claude-plugin/marketplace.json'
$marketplaceJson = Get-Content $marketplaceJsonPath -Raw | ConvertFrom-Json -AsHashtable

if ($Version) {
  $pluginJson['version'] = $Version
  $marketplaceJson['metadata']['version'] = $Version
  $marketplaceJson['plugins'][0]['version'] = $Version
  Write-Utf8LfFile -Path $pluginJsonPath -Content (($pluginJson | ConvertTo-Json -Depth 20) + "`n")
  Write-Utf8LfFile -Path $marketplaceJsonPath -Content (($marketplaceJson | ConvertTo-Json -Depth 20) + "`n")
  Write-Host "Patched version: $Version"
} else {
  $Version = [string]$pluginJson['version']
}

$manifestFiles = Get-ChildItem -Path (Join-Path $pluginOutDir 'fdf') -Filter manifest.json -Recurse -File
foreach ($manifestFile in $manifestFiles) {
  $manifestContent = [System.IO.File]::ReadAllText($manifestFile.FullName)
  Write-Utf8LfFile -Path $manifestFile.FullName -Content ($manifestContent + "`n")
}

$fileCount = (Get-ChildItem -Recurse -File $OutDir).Count
$marketplaceName = [string]$marketplaceJson['name']

Write-Host ''
Write-Host 'Claude marketplace build complete'
Write-Host "  Marketplace : $marketplaceName"
Write-Host "  Plugin      : $([string]$pluginJson['name']) v$Version"
Write-Host "  Output      : $OutDir"
Write-Host "  Files       : $fileCount"
Write-Host ''
Write-Host 'Next steps:'
Write-Host "  1. Inspect: ls '$OutDir'"
Write-Host '  2. Push to marketplace repo:'
Write-Host '       cd <feature-driven-flow-claude checkout>'
Write-Host "       pwsh -NoProfile -File tools/deploy-distribution-claude.ps1 -TargetRepoPath <feature-driven-flow-claude checkout>"
Write-Host "       git add -A && git commit -m 'Release v$Version'"
Write-Host '       git push'