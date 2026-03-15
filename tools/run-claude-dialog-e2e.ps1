[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string] $ProjectPath = '.tmp/claude-dialog-e2e-java',

  [Parameter(Mandatory = $false)]
  [string] $PluginDir = 'claude-code/plugins/feature-driven-flow',

  [Parameter(Mandatory = $false)]
  [switch] $Force
)

$ErrorActionPreference = 'Stop'
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

function Read-Jsonl {
  param([string] $Path)
  $items = New-Object System.Collections.Generic.List[object]
  foreach ($line in Get-Content $Path) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    try {
      $items.Add(($line | ConvertFrom-Json))
    } catch {
      continue
    }
  }
  return $items
}

function Invoke-ClaudeTurn {
  param(
    [Parameter(Mandatory = $true)]
    [string] $WorkDir,

    [Parameter(Mandatory = $true)]
    [string] $PromptPath,

    [Parameter(Mandatory = $true)]
    [string] $TranscriptPath,

    [Parameter(Mandatory = $true)]
    [string] $PluginDir,

    [Parameter(Mandatory = $false)]
    [string] $SessionId
  )

  $claude = (Get-Command claude.exe -ErrorAction Stop).Source
  Push-Location $WorkDir
  try {
    $args = @(
      '-p',
      '--verbose',
      '--output-format', 'stream-json',
      '--permission-mode', 'bypassPermissions',
      '--plugin-dir', $PluginDir,
      '--add-dir', $WorkDir
    )
    if (-not [string]::IsNullOrWhiteSpace($SessionId)) {
      $args += @('--resume', $SessionId)
    }

    Get-Content $PromptPath | & $claude @args | Set-Content -Path $TranscriptPath
    if ($LASTEXITCODE -ne 0) {
      throw "Claude turn failed with exit code $LASTEXITCODE"
    }
  } finally {
    Pop-Location
  }
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not [System.IO.Path]::IsPathRooted($ProjectPath)) {
  $ProjectPath = Join-Path $repoRoot $ProjectPath
}
if (-not [System.IO.Path]::IsPathRooted($PluginDir)) {
  $PluginDir = Join-Path $repoRoot $PluginDir
}

$turn1PromptPath = Join-Path $ProjectPath 'turn1-prompt.txt'
$turn2PromptPath = Join-Path $ProjectPath 'turn2-prompt.txt'
$turn1JsonlPath = Join-Path $ProjectPath 'turn1-transcript.jsonl'
$turn2JsonlPath = Join-Path $ProjectPath 'turn2-transcript.jsonl'
$combinedJsonlPath = Join-Path $ProjectPath 'session-transcript.jsonl'
$turn1LastPath = Join-Path $ProjectPath 'turn1-last-message.txt'
$turn2LastPath = Join-Path $ProjectPath 'turn2-last-message.txt'

if (Test-Path $ProjectPath) {
  if (-not $Force) {
    throw "Project path already exists: $ProjectPath. Re-run with -Force to overwrite."
  }
  Remove-Item -Recurse -Force $ProjectPath
}
New-Item -ItemType Directory -Path $ProjectPath | Out-Null

Push-Location $ProjectPath
try {
  git init | Out-Null
} finally {
  Pop-Location
}

$turn1Prompt = @'
/feature-driven-flow:fdf-start Create a minimal Java console application.
Requirements:
- Use plain Java source files.
- Print exactly Hello, World! to stdout.
- Keep the project minimal and easy to run.
- Before implementation, ask exactly one clarifying question about the Java main class name.
- Present two numbered options and recommend one:
  1. Main (Recommended)
  2. HelloApp
- Wait for my answer before implementing.
- After my answer, implement the app, compile and run it if a local JDK is available.
- Before you finish, export the active Effective Rule Matrix to .claude/feature-driven-flow/effective-rule-matrix.json.
- Before you finish, export effective instructions in compact portable form to .claude/feature-driven-flow/effective-instructions-compact-portable.json.
- Before you finish, write a concise session report to .claude/feature-driven-flow/session-report.md.
- Explicit approval is granted now for implementation after I answer the clarifying question.
'@
Write-Utf8LfFile -Path $turn1PromptPath -Content $turn1Prompt
Invoke-ClaudeTurn -WorkDir $ProjectPath -PromptPath $turn1PromptPath -TranscriptPath $turn1JsonlPath -PluginDir $PluginDir

$turn1Events = Read-Jsonl -Path $turn1JsonlPath
$initEvent = @($turn1Events | Where-Object { $_.type -eq 'system' -and $_.subtype -eq 'init' } | Select-Object -First 1)[0]
$sessionId = [string]$initEvent.session_id
if ([string]::IsNullOrWhiteSpace($sessionId)) {
  throw 'Unable to extract session id from turn1 transcript.'
}

$turn1Result = @($turn1Events | Where-Object { $_.type -eq 'result' } | Select-Object -Last 1)[0]
$turn1Text = [string]$turn1Result.result
Write-Utf8LfFile -Path $turn1LastPath -Content $turn1Text
if ($turn1Text -notmatch '1\.|2\.' -and $turn1Text -notmatch '\?') {
  throw 'Turn1 did not produce a clarifying question with options.'
}

$turn2Prompt = @'
confirmed
1
Use class name Main. Proceed with implementation, verification, and the requested FDF exports.
'@
Write-Utf8LfFile -Path $turn2PromptPath -Content $turn2Prompt
Invoke-ClaudeTurn -WorkDir $ProjectPath -PromptPath $turn2PromptPath -TranscriptPath $turn2JsonlPath -PluginDir $PluginDir -SessionId $SessionId

$turn2Events = Read-Jsonl -Path $turn2JsonlPath
$turn2Result = @($turn2Events | Where-Object { $_.type -eq 'result' } | Select-Object -Last 1)[0]
$turn2Text = [string]$turn2Result.result
Write-Utf8LfFile -Path $turn2LastPath -Content $turn2Text

$combined = @()
$combined += Get-Content $turn1JsonlPath
$combined += Get-Content $turn2JsonlPath
Write-Utf8LfFile -Path $combinedJsonlPath -Content (($combined -join "`n") + "`n")

$required = @(
  'Main.java',
  '.claude/feature-driven-flow/effective-rule-matrix.json',
  '.claude/feature-driven-flow/effective-instructions-compact-portable.json',
  '.claude/feature-driven-flow/session-report.md'
)
$missing = @($required | Where-Object { -not (Test-Path (Join-Path $ProjectPath $_)) })
if ($missing.Count -gt 0) {
  throw "Missing expected artifacts:`n$($missing -join "`n")"
}

$summary = [pscustomobject]@{
  project = $ProjectPath
  session_id = $sessionId
  transcript = $combinedJsonlPath
  turn1_last_message = $turn1LastPath
  turn2_last_message = $turn2LastPath
  effective_rule_matrix = Join-Path $ProjectPath '.claude/feature-driven-flow/effective-rule-matrix.json'
  effective_instructions = Join-Path $ProjectPath '.claude/feature-driven-flow/effective-instructions-compact-portable.json'
  session_report = Join-Path $ProjectPath '.claude/feature-driven-flow/session-report.md'
  final_message_excerpt = ($turn2Text.Trim() -replace "`r?`n", ' ')
}

$summary | ConvertTo-Json -Depth 5