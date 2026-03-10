# Effective Instructions Reuse

This document defines reusable artifacts for compiled/effective instructions derived from the confirmed Effective Rule Matrix.

## Core Principle

1. Imported compiled instructions are candidate input and still require Scope confirmation.
2. `AGENTS.md` and core workflow invariants keep higher precedence.
3. Directory bundle is canonical; compact file is transport-friendly.
4. Imported artifacts can be stale when source rules change; record provenance and ask user disposition on mismatch.
5. Content mode must be explicit: `reference|portable|hybrid`.

## Supported Formats

### 1) Directory Bundle (Canonical Structure)

Directory example:

`.codex/feature-driven-flow/effective-instructions-bundle/`

Required files:

1. `bundle.manifest.json`
2. `phases/scope.md`
3. `phases/explore.md`
4. `phases/clarify.md`
5. `phases/architect.md`
6. `phases/implement.md`
7. `phases/verify.md`
8. `phases/summarize.md`

Manifest schema:

`fdf-effective-instructions-bundle.schema.json`

Portable bundle schema (embedded content):

`fdf-effective-instructions-bundle-portable.schema.json`

### 2) Compact File

File example:

`.codex/feature-driven-flow/effective-instructions-compact.json`

Compact schema:

`fdf-effective-instructions-compact.schema.json`

Portable compact schema (embedded content):

`fdf-effective-instructions-compact-portable.schema.json`

## Content Modes

1. `reference`:
   - artifact stores references/provenance paths
   - smallest size
   - best for same environment/repo
2. `portable`:
   - artifact embeds source content used to build compiled instructions
   - best for cross-environment transfer
   - larger size, possible sensitive content exposure
3. `hybrid`:
   - includes both references and embedded content
   - better auditability + portability
   - largest size

Settings:

1. Export mode: `effective_instructions.export.content_mode`
2. Import acceptance: `effective_instructions.import.accept_content_modes`

## Custom Instructions Block

Effective instructions artifacts may include a `custom_instructions` block to carry user-specific phrases/prompts/rules.

Structure:

1. `decision`: `none|pending|approved|rejected`
2. `summary`: optional concise summary for imported/exported custom instructions
3. `approved_by`: optional approver identity text
4. `approved_at`: optional approval timestamp text
5. `items`: list of custom instruction items

Item fields:

1. `id`: stable item id
2. `kind`: `instruction|prompt|phrase|rule|constraint`
3. `origin`: `user_raw|llm_rephrase|llm_proposal|imported`
4. `state`: `draft|approved|rejected`
5. `apply_mode`: `append|prepend|replace`
6. `target_phases`: optional list of phases
7. `text`: final instruction text
8. `rephrased_from`: optional original text (when rephrased)
9. `notes`: optional context

Settings:

1. Import enable/confirmation: `effective_instructions.import.allow_custom_instructions`, `effective_instructions.import.require_custom_instructions_confirmation`
2. Export enable/approval/rephrase: `effective_instructions.export.allow_custom_instructions`, `effective_instructions.export.require_custom_instructions_approval`, `effective_instructions.export.allow_custom_instruction_rephrase`, `effective_instructions.export.allow_custom_instruction_proposals`
3. Strict approval gate: `effective_instructions.export.require_all_custom_instruction_items_approved`

## Import Interpretation Hints

Treat these as equivalent intent to import compiled instructions:

1. "load compiled instructions"
2. "import effective instructions"
3. "use instruction bundle"
4. "read compact instructions file"
5. "reuse compiled instructions"
6. "load portable instructions bundle"
7. "import compact portable instructions"

## Export Interpretation Hints

Treat these as equivalent export intent:

1. "save/export compiled instructions"
2. "save/export effective instructions"
3. "save/export instruction bundle"
4. "save/export compact instructions"
5. "save/export portable instructions bundle"
6. "save/export compact portable instructions"
7. "save with my custom instructions"
8. "export with my custom prompts"

Ambiguous terms:

1. If user says only "state" or "compiled state", ask a short clarification:
   - Effective Rule Matrix export
   - Effective Instructions export
   - run `state.json` export

## Conversion Workflows

Use converter:

The FDF conversion tool (path defined in conductor behavior).

Modes:

1. `directory-to-compact`
2. `compact-to-directory`
3. Content mode parameter:
   - `reference`
   - `portable`
   - `hybrid`
   - `preserve` (default)

Examples:

```powershell
pwsh -NoProfile -File <fdf_tools>/convert-effective-instructions.ps1 `
  -Mode directory-to-compact `
  -InputPath .codex/feature-driven-flow/effective-instructions-bundle `
  -OutputPath .codex/feature-driven-flow/effective-instructions-compact-portable.json `
  -ContentMode portable
```

```powershell
pwsh -NoProfile -File <fdf_tools>/convert-effective-instructions.ps1 `
  -Mode compact-to-directory `
  -InputPath .codex/feature-driven-flow/effective-instructions-compact-portable.json `
  -OutputPath .codex/feature-driven-flow/effective-instructions-bundle-portable `
  -ContentMode hybrid
```

## Portability Tradeoffs and Safety Notice

1. `portable|hybrid` exports are larger and consume more tokens during import.
2. Embedded content may include sensitive internal material from rules/templates/references.
3. Before sharing portable artifacts outside the team, review embedded source content.
4. Prefer `reference` mode for local same-repo workflows.
5. Prefer `portable|hybrid` only when cross-environment transfer is required.

## Scope Validation Checklist

1. Artifact format is recognized (directory or compact; standard or portable schema).
2. Artifact validates against corresponding schema.
3. Content mode is accepted by import policy (`effective_instructions.import.accept_content_modes`).
4. Embedded matrix is present and consistent with phase instructions.
5. If mode is `portable|hybrid`, `embedded_sources` is present and non-empty when provenance was expected.
6. Imported instructions do not override core invariants or `AGENTS.md`.
7. If provenance indicates drift vs current assets, ask user to accept, refresh, or discard.
8. If `custom_instructions` exists, ask user to accept, edit/rephrase, or discard it before applying.
9. For export with strict gate enabled, if any item is not `approved`, ask user to improve/rephrase and approve, skip non-approved items, or cancel export.

## Output Requirements

When compiled-instructions import/export is used, record:

1. import mode (`bundle|compact|none`) and content mode (`reference|portable|hybrid|none`)
2. source reference (path or "inline block", if ever supported)
3. validation result and mismatch notes
4. selected disposition (accept/adjust/discard)
5. exported path(s), format (`bundle|compact`), and content mode (`reference|portable|hybrid`)
6. custom instructions decision (`include|skip`), approval state, and item count
