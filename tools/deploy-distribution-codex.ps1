[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string] $TargetRepoPath,

  [Parameter(Mandatory = $false)]
  [string] $RepoRoot,

  [Parameter(Mandatory = $false)]
  [string] $Version,

  [Parameter(Mandatory = $false)]
  [switch] $Build,

  [Parameter(Mandatory = $false)]
  [switch] $Force
)

$ErrorActionPreference = "Stop"

function Sync-MirrorTree {
  param(
    [Parameter(Mandatory = $true)]
    [string] $SourceDir,

    [Parameter(Mandatory = $true)]
    [string] $TargetDir,

    [Parameter(Mandatory = $false)]
    [string[]] $ExcludeNames = @()
  )

  if (-not (Test-Path -LiteralPath $SourceDir -PathType Container)) {
    throw "Source directory not found: $SourceDir"
  }

  if (-not (Test-Path -LiteralPath $TargetDir -PathType Container)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
  }

  $sourceEntries = @{}
  foreach ($entry in Get-ChildItem -LiteralPath $SourceDir -Force) {
    $sourceEntries[$entry.Name] = $entry
  }

  foreach ($entry in Get-ChildItem -LiteralPath $TargetDir -Force) {
    if ($ExcludeNames -contains $entry.Name) { continue }
    if (-not $sourceEntries.ContainsKey($entry.Name)) {
      Remove-Item -LiteralPath $entry.FullName -Recurse -Force
    }
  }

  foreach ($entry in $sourceEntries.Values) {
    if ($ExcludeNames -contains $entry.Name) { continue }

    $destinationPath = Join-Path $TargetDir $entry.Name
    if ($entry.PSIsContainer) {
      if (Test-Path -LiteralPath $destinationPath -PathType Leaf) {
        Remove-Item -LiteralPath $destinationPath -Force
      }
      Sync-MirrorTree -SourceDir $entry.FullName -TargetDir $destinationPath
      continue
    }

    if (Test-Path -LiteralPath $destinationPath -PathType Container) {
      Remove-Item -LiteralPath $destinationPath -Recurse -Force
    }
    Copy-Item -LiteralPath $entry.FullName -Destination $destinationPath -Force
  }
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $RepoRoot) {
  $RepoRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
}

$targetRepo = (Resolve-Path $TargetRepoPath).Path
$outDir = Join-Path $RepoRoot "distrib/feature-driven-flow-codex"

if (-not (Test-Path (Join-Path $targetRepo ".git"))) {
  Write-Error "Target repo does not look like a git checkout: $targetRepo"
  exit 1
}

if ($Build -or -not (Test-Path $outDir)) {
  $buildArgs = @(
    "-NoProfile",
    "-File", (Join-Path $RepoRoot "tools/build-distribution-codex.ps1")
  )
  if ($Version) { $buildArgs += @("-Version", $Version) }
  if ($Force -or (Test-Path $outDir)) { $buildArgs += "-Force" }
  & pwsh @buildArgs
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Sync-MirrorTree -SourceDir $outDir -TargetDir $targetRepo -ExcludeNames @('.git')

Write-Host ''
Write-Host 'Codex distribution deploy sync complete'
Write-Host "  Source : $outDir"
Write-Host "  Target : $targetRepo"
Write-Host ''
Write-Host 'Next steps:'
Write-Host "  1. Review: cd '$targetRepo'"
Write-Host '  2. Inspect: git status'
Write-Host "  3. Commit: git add -A && git commit -m 'Release v<version>'"
Write-Host '  4. Push: git push'