# Settings System

Goal: keep project/framework configuration out of hardcoded rule text so teams can standardize behavior, support async workflows, and safely override defaults per repository.

Canonical settings format is JSON.

Schema:

`schemas/fdf-settings.schema.json`

## Settings Files

Global defaults shipped with this distribution:

`skills/feature-driven-flow/settings.json`

Recommended repository-local settings file:

`.codex/feature-driven-flow/settings.json`

Optional run snapshot (auto-created when persistence is enabled):

`<run_root_dir>/<run_id>/settings.snapshot.json`

## Precedence

Apply in this order:

1. Global defaults (`skills/feature-driven-flow/settings.json`) and defaults described in this document.
2. Repository-local settings (`.codex/feature-driven-flow/settings.json`) when present.
3. Run snapshot (`<run_root_dir>/<run_id>/settings.snapshot.json`) when resuming an existing run.
4. User-confirmed overrides captured during Scope (recorded in `00-run.md` and/or `decision-log.md`).

If `AGENTS.md` mandates a setting, `AGENTS.md` wins.

## Settings Keys (Recommended)

### Persistence and Async Collaboration

1. `persistence.enabled`: `true|false`
2. `persistence.run_root_dir`: default `fdf/runs`
3. `persistence.run_id_format`: default `YYYYMMDD-HHMM-<short-slug>`
4. `persistence.phase_files.enabled`: `true|false` (default `true` when persistence enabled)
5. `persistence.shared_logs.enabled`: `true|false` (default `true` when persistence enabled)
6. `async_packets.enabled`: `true|false`
7. `async_packets.dir`: default `packets` (relative to run dir)
8. `async_packets.emit_on_phases`: default `scope,clarify,architect,verify`
9. `async_packets.packet_format`: default `tui-markdown`

### Portability Exports

1. `exports.runbook.enabled`: `true|false` (default `true` when persistence enabled)
2. `exports.runbook.filename`: default `RUNBOOK.md`
3. `exports.state_json.enabled`: `true|false` (default `true` when persistence enabled)
4. `exports.state_json.filename`: default `state.json`
5. `exports.conversation_export.enabled`: `true|false` (default `false`)
6. `exports.conversation_export.filename`: default `conversation-export.md`

### Packs (Repositories Of Repositories)

Packs are optional additional asset bundles (rules/profiles/templates/references) that can be enabled per repository.

1. `packs.enabled`: list of pack ids (default in this distribution: `["async-collab","hardening","observability-lite","presets","quality"]`)
2. `packs.allow_shared_packs`: `true|false` (default `true`)
3. `packs.allow_local_packs`: `true|false` (default `true`)
4. `packs.shared_dir`: default `skills/feature-driven-flow/packs` (in this distribution)
5. `packs.local_dir`: default `.codex/feature-driven-flow/packs` (in the target repo)
6. `packs.manifest_filename`: default `manifest.json`

### Local Extensions Governance

1. `local_rules.enabled`: `true|false` (default `true`)
2. `local_profiles.enabled`: `true|false` (default `true`)
3. `local_extensions.dir_rules`: default `.codex/feature-driven-flow/rules`
4. `local_extensions.dir_profiles`: default `.codex/feature-driven-flow/profiles`
5. `overrides.allow_local_refine_shared_rules`: `true|false` (default `true`)
6. `overrides.allow_user_matrix_overrides`: `true|false` (default `true`, subject to explicit approval)

### Effective Matrix Import

1. `matrix_import.allow_file_path`: `true|false` (default `true`)
2. `matrix_import.allow_inline_block`: `true|false` (default `true`)
3. `matrix_import.default_file`: default `.codex/feature-driven-flow/effective-rule-matrix.json`
4. `matrix_import.strict_validation`: `true|false` (default `true`)

### Effective Matrix Export

1. `matrix_export.auto_generate_on_scope_confirmed`: `true|false` (default `false`)
2. `matrix_export.default_file`: default `.codex/feature-driven-flow/effective-rule-matrix.json`
3. `matrix_export.allow_user_path_override`: `true|false` (default `true`)
4. `matrix_export.allow_absolute_path`: `true|false` (default `true`)
5. `matrix_export.overwrite_existing`: `true|false` (default `true`)

### Effective Instructions Import/Export

1. `effective_instructions.import.allow_directory_bundle`: `true|false` (default `true`)
2. `effective_instructions.import.allow_compact_file`: `true|false` (default `true`)
3. `effective_instructions.import.default_directory_bundle`: default `.codex/feature-driven-flow/effective-instructions-bundle`
4. `effective_instructions.import.default_compact_file`: default `.codex/feature-driven-flow/effective-instructions-compact.json`
5. `effective_instructions.import.default_portable_directory_bundle`: default `.codex/feature-driven-flow/effective-instructions-bundle-portable`
6. `effective_instructions.import.default_portable_compact_file`: default `.codex/feature-driven-flow/effective-instructions-compact-portable.json`
7. `effective_instructions.import.accept_content_modes`: default `["reference","portable","hybrid"]`
8. `effective_instructions.import.allow_custom_instructions`: `true|false` (default `true`)
9. `effective_instructions.import.require_custom_instructions_confirmation`: `true|false` (default `true`)
10. `effective_instructions.import.strict_validation`: `true|false` (default `true`)
11. `effective_instructions.export.auto_generate_on_scope_confirmed`: `true|false` (default `false`)
12. `effective_instructions.export.default_directory_bundle`: default `.codex/feature-driven-flow/effective-instructions-bundle`
13. `effective_instructions.export.default_compact_file`: default `.codex/feature-driven-flow/effective-instructions-compact.json`
14. `effective_instructions.export.default_portable_directory_bundle`: default `.codex/feature-driven-flow/effective-instructions-bundle-portable`
15. `effective_instructions.export.default_portable_compact_file`: default `.codex/feature-driven-flow/effective-instructions-compact-portable.json`
16. `effective_instructions.export.content_mode`: `reference|portable|hybrid` (default `reference`)
17. `effective_instructions.export.embed_only_referenced_sources`: `true|false` (default `true`)
18. `effective_instructions.export.include_embedded_sha256`: `true|false` (default `true`)
19. `effective_instructions.export.allow_custom_instructions`: `true|false` (default `true`)
20. `effective_instructions.export.require_custom_instructions_approval`: `true|false` (default `true`)
21. `effective_instructions.export.require_all_custom_instruction_items_approved`: `true|false` (default `true`)
22. `effective_instructions.export.allow_custom_instruction_rephrase`: `true|false` (default `true`)
23. `effective_instructions.export.allow_custom_instruction_proposals`: `true|false` (default `true`)
24. `effective_instructions.export.allow_user_path_override`: `true|false` (default `true`)
25. `effective_instructions.export.allow_absolute_path`: `true|false` (default `true`)
26. `effective_instructions.export.overwrite_existing`: `true|false` (default `true`)

Notes:

1. When `embed_only_referenced_sources=true`, portable/hybrid export embeds only files listed in compiled-instructions provenance.
2. If provenance is incomplete, embedded content can be incomplete; user should review artifacts before cross-environment sharing.
3. When `require_custom_instructions_approval=true`, exporting with custom instructions requires explicit user confirmation of final text.
4. When `require_all_custom_instruction_items_approved=true`, export must exclude non-approved custom items (or be blocked until they are approved).

### Evidence and Output Hygiene

1. `evidence.require_file_refs`: `true|false` (default `true`)
2. `outputs.include_profile_provenance`: `true|false` (default `true`)

### Team Roles (Optional)

1. `owners.default_decision_owner`: free text
2. `owners.default_risk_owner`: free text
3. `handoff.channels`: free text list (e.g. `email`, `slack`, `jira`)

## What Belongs In Settings vs Rules

Good candidates for settings:

1. Directory paths and file naming conventions.
2. Enabling/disabling persistence and async packets.
3. Whether local rules/profiles are loaded.
4. Whether user overrides are allowed and how they are recorded.
5. Effective Rule Matrix candidate import behavior (file path and inline block).
6. Effective Rule Matrix export behavior (auto-generation, default path, path override policy).
7. Effective Instructions bundle/compact import-export behavior and default paths.
8. Output structure/provenance toggles (for example evidence and traceability verbosity).

## JSON Shape (Canonical)

Recommended structure:

```json
{
  "persistence": { "enabled": true, "run_root_dir": "fdf/runs" },
  "async_packets": { "enabled": true, "dir": "packets" },
  "exports": { "runbook": { "enabled": true, "filename": "RUNBOOK.md" } },
  "packs": { "enabled": ["async-collab"], "allow_shared_packs": true, "allow_local_packs": true },
  "local_rules": { "enabled": true },
  "local_profiles": { "enabled": true },
  "local_extensions": { "dir_rules": ".codex/feature-driven-flow/rules", "dir_profiles": ".codex/feature-driven-flow/profiles" },
  "overrides": { "allow_local_refine_shared_rules": true, "allow_user_matrix_overrides": true },
  "matrix_import": { "allow_file_path": true, "allow_inline_block": true, "default_file": ".codex/feature-driven-flow/effective-rule-matrix.json", "strict_validation": true },
  "matrix_export": { "auto_generate_on_scope_confirmed": false, "default_file": ".codex/feature-driven-flow/effective-rule-matrix.json", "allow_user_path_override": true, "allow_absolute_path": true, "overwrite_existing": true },
  "effective_instructions": {
    "import": {
      "allow_directory_bundle": true,
      "allow_compact_file": true,
      "default_directory_bundle": ".codex/feature-driven-flow/effective-instructions-bundle",
      "default_compact_file": ".codex/feature-driven-flow/effective-instructions-compact.json",
      "default_portable_directory_bundle": ".codex/feature-driven-flow/effective-instructions-bundle-portable",
      "default_portable_compact_file": ".codex/feature-driven-flow/effective-instructions-compact-portable.json",
      "accept_content_modes": ["reference", "portable", "hybrid"],
      "allow_custom_instructions": true,
      "require_custom_instructions_confirmation": true,
      "strict_validation": true
    },
    "export": {
      "auto_generate_on_scope_confirmed": false,
      "default_directory_bundle": ".codex/feature-driven-flow/effective-instructions-bundle",
      "default_compact_file": ".codex/feature-driven-flow/effective-instructions-compact.json",
      "default_portable_directory_bundle": ".codex/feature-driven-flow/effective-instructions-bundle-portable",
      "default_portable_compact_file": ".codex/feature-driven-flow/effective-instructions-compact-portable.json",
      "content_mode": "reference",
      "embed_only_referenced_sources": true,
      "include_embedded_sha256": true,
      "allow_custom_instructions": true,
      "require_custom_instructions_approval": true,
      "require_all_custom_instruction_items_approved": true,
      "allow_custom_instruction_rephrase": true,
      "allow_custom_instruction_proposals": true,
      "allow_user_path_override": true,
      "allow_absolute_path": true,
      "overwrite_existing": true
    }
  },
  "evidence": { "require_file_refs": true },
  "outputs": { "include_profile_provenance": true }
}
```

Keep in rules (not settings):

1. Phase order and hard stops.
2. Decision UX format (numbered options + recommendation).
3. Phase outputs/checks semantics (what must be produced to pass a gate).
