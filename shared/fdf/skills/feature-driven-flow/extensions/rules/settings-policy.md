# Rule: settings-policy

## id
`settings-policy`

## title
Settings Policy (Project/Framework Configuration)

## tags
`settings`, `persistence`, `governance`, `team`

## applies_to_phases
`scope`

## intent
Make configuration explicit and versionable, and reduce hardcoded behavior in rule text by loading settings and recording the effective settings for this run.

## guidance
### scope
1. Load settings, if present:
   - `../../settings.json` (global defaults)
   - `.codex/feature-driven-flow/settings.json`
2. If repo-local settings are missing, use global defaults and defaults from `../../references/settings.md`, and propose creating the repo-local settings file using `../../templates/settings.json`.
3. Record the effective settings for this run:
   - in Scope outputs
   - in `00-run.md` (if persistence is enabled)
   - as `<run_root_dir>/<run_id>/settings.snapshot.json` (if persistence is enabled)
4. Ensure settings are honored by other rules:
   - `persistence.run_root_dir` overrides the default `fdf/runs`
   - `async_packets.enabled/dir` controls packet creation behavior
   - `local_rules.enabled` and `local_profiles.enabled` control whether local extensions are loaded
   - `matrix_import.*` controls whether Effective Rule Matrix candidate import is allowed and where default file lookup occurs
   - `matrix_export.*` controls auto-generation behavior, default export path, and whether user path overrides are allowed
   - `effective_instructions.import.*` controls compiled-instructions candidate import policy and default lookup paths
   - `effective_instructions.export.*` controls compiled-instructions auto-generation behavior, default export paths, content mode (`reference|portable|hybrid`), and override policy
   - `exports.*` controls runbook/state/conversation exports

## checks
### scope
1. Effective settings are explicit (defaults + overrides).
2. If repo-local settings exist, they are referenced in outputs.
3. If persistence is enabled, a run settings snapshot path is recorded.
4. Matrix import/export settings are explicit (including export auto-generation mode and default path).
5. Effective instructions import/export settings are explicit (including auto-generation mode, default bundle/compact paths, and override policy).

## outputs
### scope
1. Effective settings summary.
2. Settings file path and status (`found|missing|proposed`).
3. If applicable, run settings snapshot path.
