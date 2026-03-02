[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [switch] $FailOnDirtyWorktree,

  [Parameter(Mandatory = $false)]
  [switch] $SkipConversionRoundtrip,

  [Parameter(Mandatory = $false)]
  [switch] $SkipManifestRegeneration
)

$ErrorActionPreference = "Stop"

$script:Results = New-Object System.Collections.Generic.List[object]

function Add-Result {
  param(
    [string] $Check,
    [ValidateSet("PASS", "FAIL", "WARN")]
    [string] $Status,
    [string] $Evidence
  )
  $script:Results.Add([pscustomobject]@{
    check = $Check
    status = $Status
    evidence = $Evidence
  })
}

function Test-NoCRLF {
  $skipExt = @(
    ".png", ".jpg", ".jpeg", ".gif", ".webp", ".ico",
    ".pdf", ".zip", ".7z", ".tar", ".gz",
    ".exe", ".dll"
  )

  $crlfFiles = Get-ChildItem -Recurse -File | ForEach-Object {
    $path = $_.FullName
    $ext = [string]$_.Extension

    if ($path -match "\\.git\\") { return }
    if (-not [string]::IsNullOrWhiteSpace($ext) -and ($skipExt -contains $ext.ToLowerInvariant())) { return }

    # Skip likely-binary files by looking for a NUL byte in the first chunk.
    $isBinary = $false
    $fs = $null
    try {
      $fs = [System.IO.File]::OpenRead($path)
      $buf = New-Object byte[] 8192
      $read = $fs.Read($buf, 0, $buf.Length)
      for ($i = 0; $i -lt $read; $i++) {
        if ($buf[$i] -eq 0) { $isBinary = $true; break }
      }
    } catch {
      # Ignore unreadable files for CRLF scan (other checks will catch real issues).
      return
    } finally {
      if ($fs) { $fs.Dispose() }
    }
    if ($isBinary) { return }

    $bytes = [System.IO.File]::ReadAllBytes($path)
    for ($i = 0; $i -lt $bytes.Length - 1; $i++) {
      if ($bytes[$i] -eq 13 -and $bytes[$i + 1] -eq 10) {
        $path
        break
      }
    }
  }

  return @($crlfFiles)
}

function Convert-ManifestsToLF {
  $files = @(
    "skills/feature-driven-flow/manifest.json",
    "skills/feature-driven-flow/extensions/manifest.json",
    "skills/feature-driven-flow/packs/async-collab/manifest.json",
    "skills/feature-driven-flow/packs/hardening/manifest.json",
    "skills/feature-driven-flow/packs/observability-lite/manifest.json",
    "skills/feature-driven-flow/packs/presets/manifest.json",
    "skills/feature-driven-flow/packs/quality/manifest.json"
  )
  foreach ($file in $files) {
    if (-not (Test-Path $file)) { continue }
    $text = Get-Content $file -Raw
    $text = $text -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText((Resolve-Path $file), $text, [System.Text.UTF8Encoding]::new($false))
  }
}

try {
  # A1
  try {
    $schema = "schemas/fdf-settings.schema.json"
    $ok = (Test-Json -Path "skills/feature-driven-flow/settings.json" -SchemaFile $schema) -and
      (Test-Json -Path "skills/feature-driven-flow/templates/settings.json" -SchemaFile $schema)
    $matrixSchema = "schemas/fdf-effective-matrix.schema.json"
    $ok = $ok -and (Test-Json -Path "skills/feature-driven-flow/templates/effective-rule-matrix.json" -SchemaFile $matrixSchema)
    $bundleSchema = "schemas/fdf-effective-instructions-bundle.schema.json"
    $ok = $ok -and (Test-Json -Path "skills/feature-driven-flow/templates/effective-instructions-bundle.manifest.json" -SchemaFile $bundleSchema)
    $compactSchema = "schemas/fdf-effective-instructions-compact.schema.json"
    $ok = $ok -and (Test-Json -Path "skills/feature-driven-flow/templates/effective-instructions-compact.json" -SchemaFile $compactSchema)
    $bundlePortableSchema = "schemas/fdf-effective-instructions-bundle-portable.schema.json"
    $ok = $ok -and (Test-Json -Path "skills/feature-driven-flow/templates/effective-instructions-bundle-portable.manifest.json" -SchemaFile $bundlePortableSchema)
    $compactPortableSchema = "schemas/fdf-effective-instructions-compact-portable.schema.json"
    $ok = $ok -and (Test-Json -Path "skills/feature-driven-flow/templates/effective-instructions-compact-portable.json" -SchemaFile $compactPortableSchema)
    Add-Result -Check "A1_SCHEMA_CONFORMANCE" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence "settings + matrix + effective-instructions templates"
  } catch {
    Add-Result -Check "A1_SCHEMA_CONFORMANCE" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # A2
  try {
    $errs = @()
    Get-ChildItem -Recurse -File -Filter *.json | ForEach-Object {
      try {
        Get-Content $_.FullName -Raw | ConvertFrom-Json | Out-Null
      } catch {
        $errs += "$($_.FullName): $($_.Exception.Message)"
      }
    }
    Add-Result -Check "A2_JSON_PARSE" -Status ($(if ($errs.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "errors=$($errs.Count)"
  } catch {
    Add-Result -Check "A2_JSON_PARSE" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # A3
  try {
    $out = pwsh -NoProfile -File tools/validate-fdf-assets.ps1 2>&1 | Out-String
    $ok = ($LASTEXITCODE -eq 0 -and $out -match "FDF asset validation passed")
    Add-Result -Check "A3_VALIDATE_FDF_ASSETS" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence $out.Trim()
  } catch {
    Add-Result -Check "A3_VALIDATE_FDF_ASSETS" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # A4
  if ($SkipConversionRoundtrip) {
    Add-Result -Check "A4_CONVERSION_ROUNDTRIP" -Status "WARN" -Evidence "skipped by flag"
  } else {
    try {
      $tmpRoot = ".tmp/effective-instructions-test"
      if (Test-Path $tmpRoot) { Remove-Item -Recurse -Force $tmpRoot }
      New-Item -ItemType Directory -Path $tmpRoot | Out-Null

      $bundleDir = Join-Path $tmpRoot "bundle"
      New-Item -ItemType Directory -Path (Join-Path $bundleDir "phases") -Force | Out-Null
      Copy-Item "skills/feature-driven-flow/templates/effective-instructions-bundle.manifest.json" (Join-Path $bundleDir "bundle.manifest.json")

      $manifestPath = Join-Path $bundleDir "bundle.manifest.json"
      $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json -AsHashtable
      $manifest.custom_instructions = @{
        decision = "approved"
        summary = "approved custom instruction set"
        approved_by = "validation-user"
        approved_at = "2026-03-04T00:00:00Z"
        items = @(
          @{
            id = "custom-1"
            kind = "instruction"
            origin = "user_raw"
            state = "approved"
            apply_mode = "append"
            target_phases = @("implement")
            text = "Prefer deterministic tests."
          }
        )
      }
      ($manifest | ConvertTo-Json -Depth 40) + "`n" | Set-Content -Path $manifestPath

      $phases = @("scope", "explore", "clarify", "architect", "implement", "verify", "summarize")
      foreach ($phase in $phases) {
        Set-Content -Path (Join-Path $bundleDir "phases/$phase.md") -Value ("# $phase`ncompiled instructions for $phase") -NoNewline
      }

      pwsh -NoProfile -File tools/convert-effective-instructions.ps1 -Mode directory-to-compact -InputPath $bundleDir -OutputPath (Join-Path $tmpRoot "compact.json") | Out-Null
      pwsh -NoProfile -File tools/convert-effective-instructions.ps1 -Mode compact-to-directory -InputPath (Join-Path $tmpRoot "compact.json") -OutputPath (Join-Path $tmpRoot "roundtrip-bundle") | Out-Null
      pwsh -NoProfile -File tools/convert-effective-instructions.ps1 -Mode directory-to-compact -InputPath $bundleDir -OutputPath (Join-Path $tmpRoot "compact-portable.json") -ContentMode portable | Out-Null
      pwsh -NoProfile -File tools/convert-effective-instructions.ps1 -Mode compact-to-directory -InputPath (Join-Path $tmpRoot "compact-portable.json") -OutputPath (Join-Path $tmpRoot "roundtrip-bundle-portable") -ContentMode hybrid | Out-Null

      $bundleSchema = "schemas/fdf-effective-instructions-bundle.schema.json"
      $compactSchema = "schemas/fdf-effective-instructions-compact.schema.json"
      $bundlePortableSchema = "schemas/fdf-effective-instructions-bundle-portable.schema.json"
      $compactPortableSchema = "schemas/fdf-effective-instructions-compact-portable.schema.json"
      $ok = (Test-Json -Path (Join-Path $tmpRoot "roundtrip-bundle/bundle.manifest.json") -SchemaFile $bundleSchema) -and
        (Test-Json -Path (Join-Path $tmpRoot "compact.json") -SchemaFile $compactSchema) -and
        (Test-Json -Path (Join-Path $tmpRoot "roundtrip-bundle-portable/bundle.manifest.json") -SchemaFile $bundlePortableSchema) -and
        (Test-Json -Path (Join-Path $tmpRoot "compact-portable.json") -SchemaFile $compactPortableSchema)

      $roundtripManifest = Get-Content (Join-Path $tmpRoot "roundtrip-bundle/bundle.manifest.json") -Raw | ConvertFrom-Json -AsHashtable
      $roundtripPortable = Get-Content (Join-Path $tmpRoot "roundtrip-bundle-portable/bundle.manifest.json") -Raw | ConvertFrom-Json -AsHashtable
      $ok = $ok -and ($roundtripManifest.custom_instructions.items.Count -eq 1) -and ($roundtripPortable.custom_instructions.items.Count -eq 1)

      if (Test-Path $tmpRoot) { Remove-Item -Recurse -Force $tmpRoot }
      Add-Result -Check "A4_CONVERSION_ROUNDTRIP" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence "bundle<->compact standard+portable + custom_instructions"
    } catch {
      Add-Result -Check "A4_CONVERSION_ROUNDTRIP" -Status "FAIL" -Evidence $_.Exception.Message
    }
  }

  # B1
  if ($SkipManifestRegeneration) {
    Add-Result -Check "B1_MANIFEST_REGEN" -Status "WARN" -Evidence "skipped by flag"
  } else {
    try {
      $out = pwsh -NoProfile -File tools/generate-fdf-manifest.ps1 2>&1 | Out-String
      $ok = ($LASTEXITCODE -eq 0)
      Add-Result -Check "B1_MANIFEST_REGEN" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence $out.Trim()
      if ($ok) { Convert-ManifestsToLF }
    } catch {
      Add-Result -Check "B1_MANIFEST_REGEN" -Status "FAIL" -Evidence $_.Exception.Message
    }
  }

  # B2/B3/B4/B5
  try {
    $m = Get-Content "skills/feature-driven-flow/extensions/manifest.json" -Raw | ConvertFrom-Json
    $missing = @()
    foreach ($r in $m.rules) { if (-not (Test-Path $r.file)) { $missing += "rule:$($r.id):$($r.file)" } }
    foreach ($p in $m.profiles) { if (-not (Test-Path $p.file)) { $missing += "profile:$($p.id):$($p.file)" } }
    foreach ($t in $m.templates) { if (-not (Test-Path $t)) { $missing += "template:$t" } }
    foreach ($r in $m.references) { if (-not (Test-Path $r)) { $missing += "reference:$r" } }
    Add-Result -Check "B2_COMBINED_MANIFEST_PATHS" -Status ($(if ($missing.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "missing=$($missing.Count)"

    $packs = Get-ChildItem "skills/feature-driven-flow/packs" -Directory
    $missing2 = @()
    foreach ($d in $packs) {
      $mf = Join-Path $d.FullName "manifest.json"
      if (-not (Test-Path $mf)) { $missing2 += "$($d.Name): missing manifest"; continue }
      $j = Get-Content $mf -Raw | ConvertFrom-Json
      foreach ($r in $j.rules) { if (-not (Test-Path $r.file)) { $missing2 += "$($d.Name): rule:$($r.id):$($r.file)" } }
      foreach ($p in $j.profiles) { if (-not (Test-Path $p.file)) { $missing2 += "$($d.Name): profile:$($p.id):$($p.file)" } }
      foreach ($t in $j.templates) { if (-not (Test-Path $t)) { $missing2 += "$($d.Name): template:$t" } }
      foreach ($r in $j.references) { if (-not (Test-Path $r)) { $missing2 += "$($d.Name): reference:$r" } }
    }
    Add-Result -Check "B3_PACK_MANIFEST_PATHS" -Status ($(if ($missing2.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "missing=$($missing2.Count)"

    $dupeRules = $m.rules | Group-Object id | Where-Object { $_.Count -gt 1 }
    $dupeProfiles = $m.profiles | Group-Object id | Where-Object { $_.Count -gt 1 }
    $okDupe = ((@($dupeRules).Count -eq 0) -and (@($dupeProfiles).Count -eq 0))
    Add-Result -Check "B4_MANIFEST_ID_UNIQUENESS" -Status ($(if ($okDupe) { "PASS" } else { "FAIL" })) -Evidence "rule_dupes=$(@($dupeRules).Count),profile_dupes=$(@($dupeProfiles).Count)"

    $validPhases = @("scope", "explore", "clarify", "architect", "implement", "verify", "summarize")
    $bad = @()
    foreach ($r in $m.rules) {
      if ($null -eq $r.applies_to_phases -or $r.applies_to_phases.Count -eq 0) { $bad += "$($r.id): empty"; continue }
      foreach ($phase in $r.applies_to_phases) {
        if ($validPhases -notcontains $phase) { $bad += "$($r.id): $phase" }
      }
    }
    Add-Result -Check "B5_RULE_PHASES" -Status ($(if ($bad.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "invalid=$($bad.Count)"
  } catch {
    Add-Result -Check "B_GROUP_MANIFEST_CHECKS" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # C1
  try {
    $cfg = Get-Content "skills/feature-driven-flow/settings.json" -Raw | ConvertFrom-Json
    $miss = @()
    foreach ($id in $cfg.packs.enabled) {
      if (-not (Test-Path (Join-Path "skills/feature-driven-flow/packs" $id))) { $miss += $id }
    }
    Add-Result -Check "C1_PACK_ENABLEMENT" -Status ($(if ($miss.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "missing=$($miss.Count)"
  } catch {
    Add-Result -Check "C1_PACK_ENABLEMENT" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # C2
  try {
    $hits = rg -n "\.codex/feature-driven-flow/settings\.md|skills/feature-driven-flow/settings\.md|settings\.snapshot\.md|templates/settings\.md" README.md skills prompts tools docs/specification.md | Out-String
    $ok = [string]::IsNullOrWhiteSpace($hits)
    Add-Result -Check "C2_SETTINGS_PATH_POLICY" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence ($(if ($ok) { "no matches" } else { "found deprecated settings markdown path" }))
  } catch {
    Add-Result -Check "C2_SETTINGS_PATH_POLICY" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # D1
  try {
    $missing = @()
    $ruleFiles = Get-ChildItem -Recurse -File -Include *.md -Path "skills/feature-driven-flow/extensions/rules", "skills/feature-driven-flow/packs"
    foreach ($f in $ruleFiles) {
      $content = Get-Content $f.FullName -Raw
      $matches = [regex]::Matches($content, '`(\.\./\.\./templates/[^`]+)`')
      foreach ($m in $matches) {
        $rel = $m.Groups[1].Value
        $target = Join-Path $f.DirectoryName $rel
        if (-not (Test-Path $target)) { $missing += "$($f.FullName): $rel" }
      }
    }
    Add-Result -Check "D1_RULE_TEMPLATE_REFS" -Status ($(if ($missing.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "missing=$($missing.Count)"
  } catch {
    Add-Result -Check "D1_RULE_TEMPLATE_REFS" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # D2
  try {
    $files = Get-ChildItem -Recurse -File -Include *.md | Where-Object { $_.FullName -notmatch "\\.git\\" }
    $problems = New-Object System.Collections.Generic.List[string]
    foreach ($f in $files) {
      $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
      if ($null -eq $content) { continue }
      $matches = [regex]::Matches([string]$content, '\[[^\]]+\]\(([^)#]+)(?:#[^)]+)?\)')
      foreach ($m in $matches) {
        $raw = $m.Groups[1].Value.Trim()
        if ([string]::IsNullOrWhiteSpace($raw)) { continue }
        if ($raw -match '^(https?:|mailto:|#)') { continue }
        if ($raw.StartsWith("/")) {
          $target = Join-Path (Get-Location) $raw.TrimStart("/", "\")
        } else {
          $target = Join-Path $f.DirectoryName $raw
        }
        if (-not (Test-Path $target)) { $problems.Add("$($f.FullName): missing link target -> $raw") }
      }
    }
    Add-Result -Check "D2_MARKDOWN_LINKS" -Status ($(if ($problems.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "broken=$($problems.Count)"
  } catch {
    Add-Result -Check "D2_MARKDOWN_LINKS" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # E1
  try {
    $skill = Get-Content "skills/feature-driven-flow/SKILL.md" -Raw
    $prompt = Get-Content "prompts/fdf-start.md" -Raw
    $ok = ($skill -match "Run Phase 1 Scope\." -and $skill -match "Run Phase 7 Summarize\.") -and ($prompt -match "Execute all 7 phases in fixed order")
    Add-Result -Check "E1_WORKFLOW_CONTRACT" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence "skill+prompt contract markers"
  } catch {
    Add-Result -Check "E1_WORKFLOW_CONTRACT" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # E2
  try {
    $ext = Get-Content "skills/feature-driven-flow/references/extension-system.md" -Raw
    $settingsRule = Get-Content "skills/feature-driven-flow/extensions/rules/settings-policy.md" -Raw
    $spec = Get-Content "docs/specification.md" -Raw
    $ok = ($ext -match "settings\.json") -and
      ($settingsRule -match "skills/feature-driven-flow/settings\.json" -and $settingsRule -match "\.codex/feature-driven-flow/settings\.json") -and
      ($spec -match "settings\.json" -and $spec -match "settings\.snapshot\.json")
    Add-Result -Check "E2_SETTINGS_PRECEDENCE_ALIGNMENT" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence "extension+rule+spec alignment"
  } catch {
    Add-Result -Check "E2_SETTINGS_PRECEDENCE_ALIGNMENT" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # F1
  try {
    $staged = (git diff --cached --name-only | Measure-Object).Count
    $unstaged = (git diff --name-only | Measure-Object).Count
    $untracked = (git ls-files --others --exclude-standard | Measure-Object).Count
    $dirty = ($staged -gt 0 -or $unstaged -gt 0 -or $untracked -gt 0)
    if ($dirty -and $FailOnDirtyWorktree) {
      Add-Result -Check "F1_WORKTREE_SHAPE" -Status "FAIL" -Evidence "staged=$staged,unstaged=$unstaged,untracked=$untracked"
    } elseif ($dirty) {
      Add-Result -Check "F1_WORKTREE_SHAPE" -Status "WARN" -Evidence "staged=$staged,unstaged=$unstaged,untracked=$untracked"
    } else {
      Add-Result -Check "F1_WORKTREE_SHAPE" -Status "PASS" -Evidence "clean"
    }
  } catch {
    Add-Result -Check "F1_WORKTREE_SHAPE" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # G1
  try {
    $promptFiles = Get-ChildItem "prompts" -File -Filter *.md | Select-Object -ExpandProperty Name
    $bad = @($promptFiles | Where-Object { $_ -ne "fdf-start.md" -and -not $_.StartsWith("fdf-") })
    Add-Result -Check "G1_PROMPT_FILE_NAMING" -Status ($(if ($bad.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "invalid=$($bad.Count)"
  } catch {
    Add-Result -Check "G1_PROMPT_FILE_NAMING" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # G2
  try {
    $hits = rg -n "/prompts:(?!fdf-)[a-z]" -P README.md docs skills prompts | Out-String
    $ok = [string]::IsNullOrWhiteSpace($hits)
    Add-Result -Check "G2_PROMPT_COMMAND_PREFIX" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence ($(if ($ok) { "all prefixed" } else { "found non-prefixed refs" }))
  } catch {
    Add-Result -Check "G2_PROMPT_COMMAND_PREFIX" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # G3
  try {
    $settings = Get-Content "skills/feature-driven-flow/settings.json" -Raw | ConvertFrom-Json
    $prompt = Get-Content "prompts/fdf-start.md" -Raw
    $skill = Get-Content "skills/feature-driven-flow/SKILL.md" -Raw
    $ok = $settings.effective_instructions.export.require_all_custom_instruction_items_approved -eq $true -and
      $prompt -match "require_all_custom_instruction_items_approved" -and
      $skill -match "require_all_custom_instruction_items_approved"
    Add-Result -Check "G3_STRICT_CUSTOM_INSTRUCTION_POLICY" -Status ($(if ($ok) { "PASS" } else { "FAIL" })) -Evidence "settings+prompt+skill aligned"
  } catch {
    Add-Result -Check "G3_STRICT_CUSTOM_INSTRUCTION_POLICY" -Status "FAIL" -Evidence $_.Exception.Message
  }

  # G4
  try {
    $crlfFiles = Test-NoCRLF
    Add-Result -Check "G4_LF_LINE_ENDINGS" -Status ($(if ($crlfFiles.Count -eq 0) { "PASS" } else { "FAIL" })) -Evidence "crlf_files=$($crlfFiles.Count)"
  } catch {
    Add-Result -Check "G4_LF_LINE_ENDINGS" -Status "FAIL" -Evidence $_.Exception.Message
  }

  $script:Results | Format-Table -AutoSize

  $failCount = @($script:Results | Where-Object { $_.status -eq "FAIL" }).Count
  if ($failCount -gt 0) {
    Write-Error "Validation cycle failed. failed_checks=$failCount"
    exit 1
  }

  Write-Host "Validation cycle passed."
  exit 0
} catch {
  Write-Error $_.Exception.Message
  exit 1
}
