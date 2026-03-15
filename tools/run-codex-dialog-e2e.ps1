
[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string] $ProjectPath = '.tmp/codex-dialog-e2e-java',

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

function Invoke-CodexTurn {
  param(
    [Parameter(Mandatory = $true)]
    [string] $WorkDir,

    [Parameter(Mandatory = $true)]
    [string] $CommandLine
  )

  Push-Location $WorkDir
  try {
    cmd /c $CommandLine
    if ($LASTEXITCODE -ne 0) {
      throw "Codex turn failed with exit code $LASTEXITCODE"
    }
  } finally {
    Pop-Location
  }
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not [System.IO.Path]::IsPathRooted($ProjectPath)) {
  $ProjectPath = Join-Path $repoRoot $ProjectPath
}

$artifactDir = Join-Path $ProjectPath '.codex/feature-driven-flow'
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
/prompts:fdf-start Create a minimal Java console application.
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
- Before you finish, export the active Effective Rule Matrix to `.codex/feature-driven-flow/effective-rule-matrix.json`.
- Before you finish, export effective instructions in compact portable form to `.codex/feature-driven-flow/effective-instructions-compact-portable.json`.
- Before you finish, write a concise session report to `.codex/feature-driven-flow/session-report.md`.
- Explicit approval is granted now for implementation after I answer the clarifying question.
'@
Write-Utf8LfFile -Path $turn1PromptPath -Content $turn1Prompt

$turn1Cmd = 'codex exec --dangerously-bypass-approvals-and-sandbox --json -o turn1-last-message.txt -C . - < turn1-prompt.txt > turn1-transcript.jsonl'
Invoke-CodexTurn -WorkDir $ProjectPath -CommandLine $turn1Cmd

$turn1Events = Read-Jsonl -Path $turn1JsonlPath
$threadId = @($turn1Events | Where-Object { $_.type -eq 'thread.started' } | Select-Object -First 1)[0].thread_id
if ([string]::IsNullOrWhiteSpace($threadId)) {
  throw 'Unable to extract session/thread id from turn1 transcript.'
}

$turn1Last = Get-Content $turn1LastPath -Raw
if ($turn1Last -notmatch '1\.|2\.' -and $turn1Last -notmatch '\?') {
  throw 'Turn1 did not produce a clarifying question with options.'
}

$turn2Prompt = @'
1
Use class name Main. Proceed with implementation, verification, and the requested FDF exports.
'@
Write-Utf8LfFile -Path $turn2PromptPath -Content $turn2Prompt

$turn2Cmd = "codex exec resume $threadId --dangerously-bypass-approvals-and-sandbox --json -o turn2-last-message.txt - < turn2-prompt.txt > turn2-transcript.jsonl"
Invoke-CodexTurn -WorkDir $ProjectPath -CommandLine $turn2Cmd

$combined = @()
$combined += Get-Content $turn1JsonlPath
$combined += Get-Content $turn2JsonlPath
Write-Utf8LfFile -Path $combinedJsonlPath -Content (($combined -join "`n") + "`n")

$required = @(
  'Main.java',
  '.codex/feature-driven-flow/effective-rule-matrix.json',
  '.codex/feature-driven-flow/effective-instructions-compact-portable.json',
  '.codex/feature-driven-flow/session-report.md'
)
$missing = @($required | Where-Object { -not (Test-Path (Join-Path $ProjectPath $_)) })
if ($missing.Count -gt 0) {
  throw "Missing expected artifacts:`n$($missing -join "`n")"
}

$turn2Last = Get-Content $turn2LastPath -Raw
$summary = [pscustomobject]@{
  project = $ProjectPath
  thread_id = $threadId
  transcript = $combinedJsonlPath
  turn1_last_message = $turn1LastPath
  turn2_last_message = $turn2LastPath
  effective_rule_matrix = Join-Path $ProjectPath '.codex/feature-driven-flow/effective-rule-matrix.json'
  effective_instructions = Join-Path $ProjectPath '.codex/feature-driven-flow/effective-instructions-compact-portable.json'
  session_report = Join-Path $ProjectPath '.codex/feature-driven-flow/session-report.md'
  final_message_excerpt = ($turn2Last.Trim() -replace "`r?`n", ' ')
}

$summary | ConvertTo-Json -Depth 5
