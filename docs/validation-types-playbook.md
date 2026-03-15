# Validation Types Playbook

Date: 2026-03-04
Scope: reusable validation catalog for `feature-driven-flow`.

## 1) Purpose

Use this document when changing shared assets, manifests, packaging scripts, settings, schemas, or entrypoints.

This is an operator and maintainer document. It is not the behavioral specification. For runtime semantics and artifact contracts, use `docs/specification.md`.
For multi-turn spawned-agent end-to-end checks, use `docs/testing/README.md` and the harness entry points `tools/run-codex-dialog-e2e.ps1` and `tools/run-claude-dialog-e2e.ps1`.

## 2) Fast Path

For normal work, start here:

```powershell
pwsh -NoProfile -File tools/run-validation-cycle.ps1
```

Interpretation:

1. `PASS` means no action for that check.
2. `WARN` means review the evidence, usually worktree hygiene.
3. `FAIL` means jump to the matching section below for diagnosis.

Use the detailed checks below only when:

1. the full runner fails
2. you are debugging one validation family
3. you are changing validation scripts themselves

Dialog E2E runs are complementary, not a replacement for this validation cycle.

Use dialog E2E when you need proof that:

1. the installed prompt is invokable
2. the installed skill is actually used
3. resumed session dialog works
4. FDF runtime exports are produced in a real agent session

## 3) Recommended Execution Order

1. Schema and structural checks.
2. Manifest generation and manifest integrity checks.
3. Cross-asset logical consistency checks.
4. Reference and link consistency checks.
5. Architecture and spec conformance checks.
6. Working tree hygiene checks.
7. Prompt namespace and line-ending checks.

## 4) Failure Triage Map

| If the failure mentions | Start with |
|---|---|
| schema, settings, matrix, compact, bundle | Group A |
| manifest, pack manifest, duplicate IDs | Group B |
| settings policy, pack enablement | Group C |
| links, template references | Group D |
| workflow contract, precedence alignment | Group E |
| worktree, staged, unstaged, untracked | Group F |
| prompt names, namespace, line endings | Group G |

## 5) Validation Groups and Types

## Group A: Schema and Structural Integrity

### A1. Settings Schema Conformance

Intent:
1. Ensure settings files match canonical schema.

Inputs:
1. `shared/fdf/schemas/fdf-settings.schema.json`
2. `shared/fdf/schemas/fdf-effective-matrix.schema.json`
3. `shared/fdf/schemas/fdf-effective-instructions-bundle.schema.json`
4. `shared/fdf/schemas/fdf-effective-instructions-compact.schema.json`
5. `shared/fdf/schemas/fdf-effective-instructions-bundle-portable.schema.json`
6. `shared/fdf/schemas/fdf-effective-instructions-compact-portable.schema.json`
7. `shared/fdf/skills/feature-driven-flow/settings.json`
8. `shared/fdf/skills/feature-driven-flow/templates/settings.json`
9. `shared/fdf/skills/feature-driven-flow/templates/effective-rule-matrix.json`
10. `shared/fdf/skills/feature-driven-flow/templates/effective-instructions-bundle.manifest.json`
11. `shared/fdf/skills/feature-driven-flow/templates/effective-instructions-compact.json`
12. `shared/fdf/skills/feature-driven-flow/templates/effective-instructions-bundle-portable.manifest.json`
13. `shared/fdf/skills/feature-driven-flow/templates/effective-instructions-compact-portable.json`
14. Optional: `.codex/feature-driven-flow/settings.json` (in target repos)
15. Optional: `.codex/feature-driven-flow/effective-rule-matrix.json` (in target repos)
16. Optional: `.codex/feature-driven-flow/effective-instructions-bundle/bundle.manifest.json` (in target repos)
17. Optional: `.codex/feature-driven-flow/effective-instructions-compact.json` (in target repos)
18. Optional: `.codex/feature-driven-flow/effective-instructions-bundle-portable/bundle.manifest.json` (in target repos)
19. Optional: `.codex/feature-driven-flow/effective-instructions-compact-portable.json` (in target repos)

Command:

```powershell
$schema='shared/fdf/schemas/fdf-settings.schema.json'
Test-Json -Path shared/fdf/skills/feature-driven-flow/settings.json -SchemaFile $schema
Test-Json -Path shared/fdf/skills/feature-driven-flow/templates/settings.json -SchemaFile $schema
$matrixSchema='shared/fdf/schemas/fdf-effective-matrix.schema.json'
Test-Json -Path shared/fdf/skills/feature-driven-flow/templates/effective-rule-matrix.json -SchemaFile $matrixSchema
$bundleSchema='shared/fdf/schemas/fdf-effective-instructions-bundle.schema.json'
Test-Json -Path shared/fdf/skills/feature-driven-flow/templates/effective-instructions-bundle.manifest.json -SchemaFile $bundleSchema
$compactSchema='shared/fdf/schemas/fdf-effective-instructions-compact.schema.json'
Test-Json -Path shared/fdf/skills/feature-driven-flow/templates/effective-instructions-compact.json -SchemaFile $compactSchema
$bundlePortableSchema='shared/fdf/schemas/fdf-effective-instructions-bundle-portable.schema.json'
Test-Json -Path shared/fdf/skills/feature-driven-flow/templates/effective-instructions-bundle-portable.manifest.json -SchemaFile $bundlePortableSchema
$compactPortableSchema='shared/fdf/schemas/fdf-effective-instructions-compact-portable.schema.json'
Test-Json -Path shared/fdf/skills/feature-driven-flow/templates/effective-instructions-compact-portable.json -SchemaFile $compactPortableSchema
```

Pass criteria:
1. All checks return `True`.

Common failures:
1. Wrong type for `packs.enabled` (must be array).
2. Unknown top-level properties (schema uses `additionalProperties: false`).
3. Invalid phase names in `async_packets.emit_on_phases`.
4. Invalid matrix artifact shape (missing phases or wrong `schema` value).
5. Invalid compiled-instructions bundle/compact shape.
6. Invalid portable compiled-instructions bundle/compact shape.

### A2. JSON Parse Integrity

Intent:
1. Ensure all JSON files are syntactically valid.

Command:

```powershell
$errs = @()
Get-ChildItem -Recurse -File -Filter *.json | ForEach-Object {
  try { Get-Content $_.FullName -Raw | ConvertFrom-Json | Out-Null }
  catch { $errs += "$($_.FullName): $($_.Exception.Message)" }
}
if($errs.Count -eq 0){ 'JSON_PARSE_OK' } else { 'JSON_PARSE_FAIL'; $errs }
```

Pass criteria:
1. `JSON_PARSE_OK`.

### A3. Rule/Profile Core Structural Validation

Intent:
1. Validate rule/profile IDs, phases, and profile rule references.
2. Validate settings files against settings schema (built into script).
3. Validate effective matrix template against effective matrix schema (built into script).
4. Validate effective instructions bundle/compact templates against their schemas (built into script).
5. Validate portable effective instructions bundle/compact templates against their schemas (built into script).

Command:

```powershell
pwsh -File tools/validate-fdf-assets.ps1
```

Pass criteria:
1. Output includes `FDF asset validation passed.`

Failure meaning:
1. Broken rule/profile metadata.
2. Bad `applies_to_phases`.
3. Unknown rule IDs in profiles.
4. Settings schema mismatch.
5. Effective matrix artifact schema mismatch.
6. Effective instructions artifact schema mismatch.
7. Effective instructions portable artifact schema mismatch.

### A4. Effective Instructions Conversion Roundtrip

Intent:
1. Ensure `directory-to-compact` and `compact-to-directory` conversion both work and produce schema-valid outputs.

Command:

```powershell
$tmpRoot = '.tmp/effective-instructions-test'
if(Test-Path $tmpRoot){ Remove-Item -Recurse -Force $tmpRoot }
New-Item -ItemType Directory -Path $tmpRoot | Out-Null
$bundleDir = Join-Path $tmpRoot 'bundle'
New-Item -ItemType Directory -Path (Join-Path $bundleDir 'phases') -Force | Out-Null
Copy-Item 'shared/fdf/skills/feature-driven-flow/templates/effective-instructions-bundle.manifest.json' (Join-Path $bundleDir 'bundle.manifest.json')
$manifestPath = Join-Path $bundleDir 'bundle.manifest.json'
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json -AsHashtable
$manifest.custom_instructions = @{
  decision = 'approved'
  summary = 'approved custom instruction set'
  approved_by = 'validation-user'
  approved_at = '2026-03-04T00:00:00Z'
  items = @(
    @{
      id = 'custom-1'
      kind = 'instruction'
      origin = 'user_raw'
      state = 'approved'
      apply_mode = 'append'
      target_phases = @('implement')
      text = 'Prefer deterministic tests.'
    }
  )
}
($manifest | ConvertTo-Json -Depth 40) + "`n" | Set-Content -Path $manifestPath
$phases=@('scope','explore','clarify','architect','implement','verify','summarize')
foreach($p in $phases){ Set-Content -Path (Join-Path $bundleDir "phases/$p.md") -Value ("# $p`ncompiled instructions for $p") -NoNewline }
pwsh -NoProfile -File shared/fdf/scripts/convert-effective-instructions.ps1 -Mode directory-to-compact -InputPath $bundleDir -OutputPath (Join-Path $tmpRoot 'compact.json')
pwsh -NoProfile -File shared/fdf/scripts/convert-effective-instructions.ps1 -Mode compact-to-directory -InputPath (Join-Path $tmpRoot 'compact.json') -OutputPath (Join-Path $tmpRoot 'roundtrip-bundle')
pwsh -NoProfile -File shared/fdf/scripts/convert-effective-instructions.ps1 -Mode directory-to-compact -InputPath $bundleDir -OutputPath (Join-Path $tmpRoot 'compact-portable.json') -ContentMode portable
pwsh -NoProfile -File shared/fdf/scripts/convert-effective-instructions.ps1 -Mode compact-to-directory -InputPath (Join-Path $tmpRoot 'compact-portable.json') -OutputPath (Join-Path $tmpRoot 'roundtrip-bundle-portable') -ContentMode hybrid
$bundleSchema='shared/fdf/schemas/fdf-effective-instructions-bundle.schema.json'
$compactSchema='shared/fdf/schemas/fdf-effective-instructions-compact.schema.json'
Test-Json -Path (Join-Path $tmpRoot 'roundtrip-bundle/bundle.manifest.json') -SchemaFile $bundleSchema
Test-Json -Path (Join-Path $tmpRoot 'compact.json') -SchemaFile $compactSchema
$bundlePortableSchema='shared/fdf/schemas/fdf-effective-instructions-bundle-portable.schema.json'
$compactPortableSchema='shared/fdf/schemas/fdf-effective-instructions-compact-portable.schema.json'
Test-Json -Path (Join-Path $tmpRoot 'roundtrip-bundle-portable/bundle.manifest.json') -SchemaFile $bundlePortableSchema
Test-Json -Path (Join-Path $tmpRoot 'compact-portable.json') -SchemaFile $compactPortableSchema
$roundtripManifest = Get-Content (Join-Path $tmpRoot 'roundtrip-bundle/bundle.manifest.json') -Raw | ConvertFrom-Json -AsHashtable
if($roundtripManifest.custom_instructions.items.Count -ne 1){ throw 'custom_instructions was not preserved in standard roundtrip' }
if([string]$roundtripManifest.custom_instructions.items[0].text -ne 'Prefer deterministic tests.'){ throw 'custom_instructions text mismatch in standard roundtrip' }
$roundtripPortableManifest = Get-Content (Join-Path $tmpRoot 'roundtrip-bundle-portable/bundle.manifest.json') -Raw | ConvertFrom-Json -AsHashtable
if($roundtripPortableManifest.custom_instructions.items.Count -ne 1){ throw 'custom_instructions was not preserved in portable roundtrip' }
if(Test-Path $tmpRoot){ Remove-Item -Recurse -Force $tmpRoot }
```

Pass criteria:
1. Conversion commands succeed.
2. All standard and portable/hybrid `Test-Json` checks return `True`.
3. `custom_instructions` payload survives both roundtrips.

## Group B: Manifest and Index Consistency

### B1. Manifest Regeneration

Intent:
1. Ensure manifests can be regenerated from current assets.

Command:

```powershell
pwsh -File tools/generate-fdf-manifest.ps1
```

Pass criteria:
1. Output includes `Wrote manifest: .../shared/fdf/skills/feature-driven-flow/extensions/manifest.json`.

### B2. Combined Manifest Path Integrity

Intent:
1. Ensure every asset path in combined manifest exists.

Command:

```powershell
$m = Get-Content 'shared/fdf/skills/feature-driven-flow/extensions/manifest.json' -Raw | ConvertFrom-Json
$missing = @()
foreach($r in $m.rules){ if(-not (Test-Path $r.file)){ $missing += "rule:$($r.id):$($r.file)" } }
foreach($p in $m.profiles){ if(-not (Test-Path $p.file)){ $missing += "profile:$($p.id):$($p.file)" } }
foreach($t in $m.templates){ if(-not (Test-Path $t)){ $missing += "template:$t" } }
foreach($r in $m.references){ if(-not (Test-Path $r)){ $missing += "reference:$r" } }
if($missing.Count -eq 0){ 'MANIFEST_PATHS_OK' } else { 'MANIFEST_PATHS_MISSING'; $missing }
```

Pass criteria:
1. `MANIFEST_PATHS_OK`.

### B3. Per-Pack Manifest Path Integrity

Intent:
1. Ensure each pack manifest references existing files.

Command:

```powershell
$packs = Get-ChildItem 'shared/fdf/skills/feature-driven-flow/packs' -Directory
$missing=@()
foreach($d in $packs){
  $mf = Join-Path $d.FullName 'manifest.json'
  if(-not (Test-Path $mf)){ $missing += "$($d.Name): missing manifest"; continue }
  $j = Get-Content $mf -Raw | ConvertFrom-Json
  foreach($r in $j.rules){ if(-not (Test-Path $r.file)){ $missing += "$($d.Name): rule:$($r.id):$($r.file)" } }
  foreach($p in $j.profiles){ if(-not (Test-Path $p.file)){ $missing += "$($d.Name): profile:$($p.id):$($p.file)" } }
  foreach($t in $j.templates){ if(-not (Test-Path $t)){ $missing += "$($d.Name): template:$t" } }
  foreach($r in $j.references){ if(-not (Test-Path $r)){ $missing += "$($d.Name): reference:$r" } }
}
if($missing.Count -eq 0){ 'PACK_MANIFEST_PATHS_OK' } else { 'PACK_MANIFEST_PATHS_MISSING'; $missing }
```

Pass criteria:
1. `PACK_MANIFEST_PATHS_OK`.

### B4. Manifest ID Uniqueness

Intent:
1. Ensure no duplicate rule/profile IDs in compiled asset space.

Command:

```powershell
$m = Get-Content 'shared/fdf/skills/feature-driven-flow/extensions/manifest.json' -Raw | ConvertFrom-Json
$dupeRules = $m.rules | Group-Object id | Where-Object { $_.Count -gt 1 }
$dupeProfiles = $m.profiles | Group-Object id | Where-Object { $_.Count -gt 1 }
if((@($dupeRules).Count -eq 0) -and (@($dupeProfiles).Count -eq 0)){ 'MANIFEST_IDS_OK' } else { 'MANIFEST_IDS_DUPLICATE' }
```

Pass criteria:
1. `MANIFEST_IDS_OK`.

### B5. Rule Phase Applicability Integrity

Intent:
1. Ensure manifest rule phases belong to canonical phase set.

Command:

```powershell
$valid = @('scope','explore','clarify','architect','implement','verify','summarize')
$m = Get-Content 'shared/fdf/skills/feature-driven-flow/extensions/manifest.json' -Raw | ConvertFrom-Json
$bad = @()
foreach($r in $m.rules){
  if($null -eq $r.applies_to_phases -or $r.applies_to_phases.Count -eq 0){ $bad += "$($r.id): empty"; continue }
  foreach($p in $r.applies_to_phases){ if($valid -notcontains $p){ $bad += "$($r.id): $p" } }
}
if($bad.Count -eq 0){ 'RULE_PHASES_OK' } else { 'RULE_PHASES_INVALID'; $bad }
```

Pass criteria:
1. `RULE_PHASES_OK`.

## Group C: Configuration and Policy Consistency

### C1. Pack Enablement Resolution

Intent:
1. Ensure enabled packs in settings exist on disk.

Command:

```powershell
$cfg = Get-Content 'shared/fdf/skills/feature-driven-flow/settings.json' -Raw | ConvertFrom-Json
$miss=@()
foreach($id in $cfg.packs.enabled){
  if(-not (Test-Path (Join-Path 'shared/fdf/skills/feature-driven-flow/packs' $id))){ $miss += $id }
}
if($miss.Count -eq 0){ 'PACK_ENABLEMENT_OK' } else { 'PACK_ENABLEMENT_MISSING'; $miss }
```

Pass criteria:
1. `PACK_ENABLEMENT_OK`.

### C2. JSON-Only Settings Path Policy

Intent:
1. Ensure active guidance does not point to removed markdown settings paths.

Command:

```powershell
rg -n "\.codex/feature-driven-flow/settings\.md|shared/fdf/skills/feature-driven-flow/settings\.md|settings\.snapshot\.md|templates/settings\.md" README.md codex claude-code tools docs/specification.md
```

Pass criteria:
1. No matches.

## Group D: Content Reference Integrity

### D1. Rule-to-Template Relative References

Intent:
1. Ensure template references in rules resolve to existing files.

Command:

```powershell
$missing = @()
$ruleFiles = Get-ChildItem -Recurse -File -Include *.md -Path 'shared/fdf/skills/feature-driven-flow/extensions/rules','shared/fdf/skills/feature-driven-flow/packs'
foreach($f in $ruleFiles){
  $content = Get-Content $f.FullName -Raw
  $matches = [regex]::Matches($content,'`(\.\./\.\./templates/[^`]+)`')
  foreach($m in $matches){
    $rel = $m.Groups[1].Value
    $target = Join-Path $f.DirectoryName $rel
    if(-not (Test-Path $target)){ $missing += "$($f.FullName): $rel" }
  }
}
if($missing.Count -eq 0){ 'RULE_TEMPLATE_REFS_OK' } else { 'RULE_TEMPLATE_REFS_MISSING'; $missing }
```

Pass criteria:
1. `RULE_TEMPLATE_REFS_OK`.

### D2. Markdown Local Link Integrity

Intent:
1. Ensure markdown links to local files are valid.

Command:

```powershell
$files = Get-ChildItem -Recurse -File -Include *.md | Where-Object { $_.FullName -notmatch '\\.git\\' }
$problems = New-Object System.Collections.Generic.List[string]
foreach($f in $files){
  $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
  if($null -eq $content){ continue }
  $matches = [regex]::Matches([string]$content,'\[[^\]]+\]\(([^)#]+)(?:#[^)]+)?\)')
  foreach($m in $matches){
    $raw = $m.Groups[1].Value.Trim()
    if([string]::IsNullOrWhiteSpace($raw)){ continue }
    if($raw -match '^(https?:|mailto:|#)'){ continue }
    if($raw.StartsWith('/')){ $target = Join-Path (Get-Location) $raw.TrimStart('/','\') } else { $target = Join-Path $f.DirectoryName $raw }
    if(-not (Test-Path $target)){ $problems.Add("$($f.FullName): missing link target -> $raw") }
  }
}
if($problems.Count -eq 0){ 'MARKDOWN_LINKS_OK' } else { 'MARKDOWN_LINKS_BROKEN'; $problems }
```

Pass criteria:
1. `MARKDOWN_LINKS_OK`.

## Group E: Architecture Conformance Checks

### E1. Workflow Contract Presence

Intent:
1. Ensure conductor and prompt still enforce seven-phase execution model.

Command:

```powershell
$skill = Get-Content 'codex/skills/feature-driven-flow/SKILL.md' -Raw
$prompt = Get-Content 'codex/prompts/fdf-start.md' -Raw
"SKILL_has_7_phase_contract=$($skill -match 'Run Phase 1 Scope\.' -and $skill -match 'Run Phase 7 Summarize\.')"
"PROMPT_has_7_phase_requirement=$($prompt -match 'Execute all 7 phases in fixed order')"
```

Pass criteria:
1. Both values are `True`.

### E2. Settings/Precedence Semantic Alignment

Intent:
1. Ensure extension system, settings policy, and specification align on JSON settings and precedence.

Command:

```powershell
$ext = Get-Content 'shared/fdf/skills/feature-driven-flow/references/extension-system.md' -Raw
$settingsRule = Get-Content 'shared/fdf/skills/feature-driven-flow/extensions/rules/settings-policy.md' -Raw
$spec = Get-Content 'docs/specification.md' -Raw
"EXT_precedence_mentions_settings_json=$($ext -match 'settings\.json')"
"SETTINGS_POLICY_json_paths=$($settingsRule -match 'skills/feature-driven-flow/settings\.json' -and $settingsRule -match '\.codex/feature-driven-flow/settings\.json')"
"SPEC_settings_json=$($spec -match 'settings\.json' -and $spec -match 'settings\.snapshot\.json')"
```

Pass criteria:
1. All values are `True`.

## Group F: SCM Hygiene (Operational)

### F1. Working Tree Shape

Intent:
1. Detect unsafe or unexpected repository dirt before release.

Commands:

```powershell
git status --short
git status --porcelain=v1 | Measure-Object
git diff --name-only | Measure-Object
git diff --cached --name-only | Measure-Object
git ls-files --others --exclude-standard | Measure-Object
```

Pass criteria:
1. Depends on release policy.
2. For strict release gate: no unstaged changes, no untracked files, only intentional staged changes.

## Group G: Namespace and Enforcement Integrity

### G1. Prompt File Naming Convention

Intent:
1. Ensure prompt command files use enforced `fdf-` prefix, except entrypoint `fdf-start.md`.

Command:

```powershell
$promptFiles = Get-ChildItem codex/prompts -File -Filter *.md | Select-Object -ExpandProperty Name
$bad = @($promptFiles | Where-Object { $_ -ne 'fdf-start.md' -and -not $_.StartsWith('fdf-') })
if($bad.Count -eq 0){ 'PROMPT_FILE_NAMING_OK' } else { 'PROMPT_FILE_NAMING_FAIL'; $bad }
```

Pass criteria:
1. `PROMPT_FILE_NAMING_OK`.

### G2. Prompt Command Prefix Reference Integrity

Intent:
1. Ensure no `/prompts:` references use non-prefixed command names.

Command:

```powershell
rg -n "/prompts:(?!fdf-)[a-z]" -P README.md docs codex claude-code
```

Pass criteria:
1. No matches.

### G3. Strict Custom-Instructions Export Policy Integrity

Intent:
1. Ensure strict approved-only custom-instruction export policy is aligned in settings and conductor guidance.

Command:

```powershell
$settings = Get-Content 'shared/fdf/skills/feature-driven-flow/settings.json' -Raw | ConvertFrom-Json
$prompt = Get-Content 'codex/prompts/fdf-start.md' -Raw
$skill = Get-Content 'codex/skills/feature-driven-flow/SKILL.md' -Raw
"SETTINGS_STRICT_FLAG=$($settings.effective_instructions.export.require_all_custom_instruction_items_approved -eq $true)"
"PROMPT_STRICT_GUIDANCE=$($prompt -match 'require_all_custom_instruction_items_approved')"
"SKILL_STRICT_GUIDANCE=$($skill -match 'require_all_custom_instruction_items_approved')"
```

Pass criteria:
1. All values are `True`.

### G4. LF Line Endings Integrity

Intent:
1. Ensure repository does not contain CRLF line endings in text files.
2. Binary files can contain CRLF byte sequences and must be excluded from this check.

Command:

```powershell
$skipExt = @(
  ".png", ".jpg", ".jpeg", ".gif", ".webp", ".ico",
  ".pdf", ".zip", ".7z", ".tar", ".gz",
  ".exe", ".dll"
)

$crlf = Get-ChildItem -Recurse -File | ForEach-Object {
  $p = $_.FullName
  $ext = [string]$_.Extension
  if($p -match "\\.git\\"){ return }
  if(-not [string]::IsNullOrWhiteSpace($ext) -and ($skipExt -contains $ext.ToLowerInvariant())){ return }

  $fs = $null
  $isBinary = $false
  try {
    $fs = [System.IO.File]::OpenRead($p)
    $buf = New-Object byte[] 8192
    $read = $fs.Read($buf, 0, $buf.Length)
    for($i=0;$i -lt $read;$i++){ if($buf[$i] -eq 0){ $isBinary = $true; break } }
  } finally {
    if($fs){ $fs.Dispose() }
  }
  if($isBinary){ return }

  $bytes = [System.IO.File]::ReadAllBytes($p)
  for($i=0;$i -lt $bytes.Length-1;$i++){
    if($bytes[$i]-eq 13 -and $bytes[$i+1]-eq 10){ $p; break }
  }
}

if(@($crlf).Count -eq 0){ 'LF_ONLY_OK' } else { 'LF_ONLY_FAIL'; $crlf }
```

Pass criteria:
1. `LF_ONLY_OK`.
## 6) One-Command Validation Runner

Use `tools/run-validation-cycle.ps1` to run Groups A-G in sequence and print a compact status table.
This should be the default validation entrypoint.

Standard run:

```powershell
pwsh -NoProfile -File tools/run-validation-cycle.ps1
```

Strict SCM gate:

```powershell
pwsh -NoProfile -File tools/run-validation-cycle.ps1 -FailOnDirtyWorktree
```

Optional flags:

1. `-SkipConversionRoundtrip`
2. `-SkipManifestRegeneration`

## 7) Release Gate Recommendation

Before final merge:

1. All checks in Groups A-E and G must pass.
2. Group F must be explicitly reviewed and accepted.
3. `tools/run-validation-cycle.ps1` should be the default pre-merge gate in CI and local release checks.
4. Manifest regeneration must be committed if changed.

## 8) Document Boundary

This playbook answers:

1. what to run
2. how to interpret failures
3. what counts as a release gate

It does not redefine FDF runtime behavior. Keep behavior changes in `docs/specification.md` and repository-layout changes in `docs/fdf-cross-agent-architecture.md`.
