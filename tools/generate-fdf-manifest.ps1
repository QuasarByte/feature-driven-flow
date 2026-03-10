[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string] $RepoRoot,

  [Parameter(Mandatory = $false)]
  [string] $OutFile,

  [Parameter(Mandatory = $false)]
  [string] $PacksDir
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $RepoRoot) {
  $RepoRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
}
if (-not $OutFile) {
  $OutFile = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/extensions/manifest.json"
}
if (-not $PacksDir) {
  $PacksDir = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/packs"
}

function Get-HeadingBody([string] $content, [string] $field) {
  $pattern = '(?ms)^##\s+' + [Regex]::Escape($field) + '\s*(?:\r?\n)+(.*?)(?=^##\s+|\z)'
  if ($content -match $pattern) { return ($Matches[1]) }
  return ""
}

function Get-FieldText([string] $content, [string] $field) {
  $body = (Get-HeadingBody $content $field).Trim()
  if (-not $body) { return $null }
  return $body
}

function Get-BacktickTokens([string] $text) {
  return @([Regex]::Matches($text, '`([^`]+)`') | ForEach-Object { $_.Groups[1].Value.Trim() } | Where-Object { $_ -ne "" })
}

function Get-HeadingTokens([string] $content, [string] $field) {
  $body = Get-HeadingBody $content $field
  return (Get-BacktickTokens $body)
}

function Get-FirstHeadingToken([string] $content, [string] $field) {
  $toks = @(Get-HeadingTokens $content $field)
  if ($toks.Count -gt 0) { return $toks[0] }
  return $null
}

function Get-Tags([string] $content) {
  return (Get-HeadingTokens $content "tags")
}

function Get-AppliesToPhases([string] $content) {
  return (Get-HeadingTokens $content "applies_to_phases")
}

function Get-ProfileAlwaysRules([string] $content) {
  $lines = $content -split "\r?\n"
  $inAlways = $false
  $out = New-Object System.Collections.Generic.List[string]
  foreach ($line in $lines) {
    if ($line -match '^\s*###\s+always\b') { $inAlways = $true; continue }
    if (-not $inAlways) { continue }
    if ($line -match '^\s*###\s+' -or $line -match '^\s*##\s+') { break }
    foreach ($m in [Regex]::Matches($line, '`([^`]+)`')) {
      $tok = $m.Groups[1].Value.Trim()
      if ($tok) { $out.Add($tok) }
    }
  }
  return @($out)
}

function Get-PackAssets([string] $packId, [string] $packRoot) {
  $rulesDir = Join-Path $packRoot "extensions/rules"
  $profilesDir = Join-Path $packRoot "extensions/profiles"
  $templatesDir = Join-Path $packRoot "templates"
  $referencesDir = Join-Path $packRoot "references"

  $rules = @()
  if (Test-Path $rulesDir) {
    foreach ($f in (Get-ChildItem -Path $rulesDir -Filter *.md -File | Sort-Object Name)) {
      $c = Get-Content $f.FullName -Raw
      $rules += [ordered]@{
        pack_id = $packId
        id = (Get-FirstHeadingToken $c "id")
        title = (Get-FieldText $c "title")
        tags = @((Get-Tags $c))
        applies_to_phases = @((Get-AppliesToPhases $c))
        intent = (Get-FieldText $c "intent")
        file = ($f.FullName.Substring($RepoRoot.Length).TrimStart("\","/") -replace "\\", "/")
      }
    }
  }

  $profiles = @()
  if (Test-Path $profilesDir) {
    foreach ($f in (Get-ChildItem -Path $profilesDir -Filter *.md -File | Sort-Object Name)) {
      $c = Get-Content $f.FullName -Raw
      $extends = @((Get-HeadingTokens $c "extends"))
      $profiles += [ordered]@{
        pack_id = $packId
        id = (Get-FirstHeadingToken $c "id")
        title = (Get-FieldText $c "title")
        intent = (Get-FieldText $c "intent")
        extends = @()
        always_rules = @((Get-ProfileAlwaysRules $c))
        file = ($f.FullName.Substring($RepoRoot.Length).TrimStart("\","/") -replace "\\", "/")
      }
      if ($extends.Count -gt 0) { $profiles[-1].extends = @($extends) }
    }
  }

  $templates = @()
  if (Test-Path $templatesDir) {
    $templateFiles = @()
    $templateFiles += @(Get-ChildItem -Path $templatesDir -Filter *.md -File)
    $templateFiles += @(Get-ChildItem -Path $templatesDir -Filter *.json -File)
    $templateFiles += @(Get-ChildItem -Path $templatesDir -Filter *.jsonc -File)
    foreach ($f in ($templateFiles | Sort-Object Name -Unique)) {
      $templates += ($f.FullName.Substring($RepoRoot.Length).TrimStart("\","/") -replace "\\", "/")
    }
  }

  $references = @()
  if (Test-Path $referencesDir) {
    foreach ($f in (Get-ChildItem -Path $referencesDir -Filter *.md -File | Sort-Object Name)) {
      $references += ($f.FullName.Substring($RepoRoot.Length).TrimStart("\","/") -replace "\\", "/")
    }
  }

  return [ordered]@{
    pack_id = $packId
    pack_root = ($packRoot.Substring($RepoRoot.Length).TrimStart("\","/") -replace "\\", "/")
    rules = $rules
    profiles = $profiles
    templates = $templates
    references = $references
  }
}

$coreRoot = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow"
$core = Get-PackAssets "core" $coreRoot

$packs = @()
if (Test-Path $PacksDir) {
  foreach ($d in (Get-ChildItem -Path $PacksDir -Directory | Sort-Object Name)) {
    $packs += (Get-PackAssets $d.Name $d.FullName)
  }
}

$allRules = @($core.rules)
$allProfiles = @($core.profiles)
$allTemplates = @($core.templates)
$allReferences = @($core.references)
foreach ($p in $packs) {
  $allRules += $p.rules
  $allProfiles += $p.profiles
  $allTemplates += $p.templates
  $allReferences += $p.references
}

$manifest = [ordered]@{
  schema = "fdf/manifest.v1"
  generated_at = (Get-Date).ToString("s")
  packs = @(
    [ordered]@{ pack_id = "core"; pack_root = $core.pack_root }
  )
  rules = $allRules
  profiles = $allProfiles
  templates = $allTemplates
  references = $allReferences
}
foreach ($p in $packs) {
  $manifest.packs += [ordered]@{ pack_id = $p.pack_id; pack_root = $p.pack_root }
}

# Also emit per-pack manifests (core + packs) for direct consumption.
$perPack = @($core) + $packs
foreach ($p in $perPack) {
  if ($p.pack_id -eq "core") {
    $packOut = Join-Path $RepoRoot "shared/fdf/skills/feature-driven-flow/manifest.json"
  } else {
    $packOut = Join-Path $RepoRoot ("shared/fdf/skills/feature-driven-flow/packs/" + $p.pack_id + "/manifest.json")
  }
  $packObj = [ordered]@{
    schema = "fdf/pack-manifest.v1"
    generated_at = (Get-Date).ToString("s")
    pack_id = $p.pack_id
    pack_root = $p.pack_root
    rules = $p.rules
    profiles = $p.profiles
    templates = $p.templates
    references = $p.references
  }
  $packDir = Split-Path -Parent $packOut
  if (-not (Test-Path $packDir)) { New-Item -ItemType Directory -Path $packDir | Out-Null }
  [System.IO.File]::WriteAllText($packOut, ($packObj | ConvertTo-Json -Depth 10) + "`n", [System.Text.Encoding]::UTF8)
}

$outDir = Split-Path -Parent $OutFile
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$json = $manifest | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($OutFile, $json + "`n", [System.Text.Encoding]::UTF8)

Write-Host "Wrote manifest: $OutFile"
