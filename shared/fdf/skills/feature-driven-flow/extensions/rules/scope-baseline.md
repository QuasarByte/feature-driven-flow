# Rule: scope-baseline

## id
`scope-baseline`

## title
Scope Baseline

## tags
`process`, `scope`

## applies_to_phases
`scope`

## intent
Establish shared understanding and lock the Effective Rule Matrix (phase-by-phase active rules) before execution.

## guidance
### scope
1. Restate desired outcome, scope boundaries, and success criteria.
2. Infer execution context using request text, repository signals, and `AGENTS.md`.
   Record structured context fields using `../../references/context-model.md`.
3. Detect whether user supplied an Effective Rule Matrix candidate (file path or inline block), including phrases like load/import/use/read/reuse matrix.
   Parse and normalize candidate input using `../../references/effective-matrix-reuse.md`.
4. Validate candidate (when provided):
   - all phases present
   - rule IDs exist
   - rule applicability matches phase
   - no conflict with core invariants or `AGENTS.md`
5. Detect whether user supplied compiled/effective instructions candidate (directory bundle or compact file; reference or portable content mode).
   Parse and validate candidate input using `../../references/effective-instructions-reuse.md`.
6. If compiled/effective instructions candidate is provided, ask user to accept imported instructions, refresh from current assets, or discard candidate.
7. If matrix candidate is missing or fails validation, propose profile selection (base + optional overlays) with one recommended baseline set and compile a matrix.
8. Present the resulting candidate matrix as the Effective Rule Matrix.
   In markdown files, render it as a native markdown table (`| Phase | Active rules |`) with one row per phase.
   In each "Active rules" cell, list backticked rule ids separated by commas.
   In terminal/chat output, do not render a table; render only a plain-text phase list.
9. Capture explicit user acceptance or edits to the selected profiles and/or Effective Rule Matrix.
10. Effective matrix save/export:
   - If `matrix_export.auto_generate_on_scope_confirmed=true`, save confirmed matrix automatically.
   - If user asks to save/export current|active|chosen|choice|effective|compiled matrix, export on demand.
   - If user asks only for `state` or `compiled state`, ask for clarification between Effective Rule Matrix export, Effective Instructions export, and `state.json` export before saving.
   - Use explicit user path when allowed; otherwise use `matrix_export.default_file`.
   - Resolve relative paths from repository root and record exported path(s).
   - Allow absolute paths only when `matrix_export.allow_absolute_path=true`.
   - Respect `matrix_export.overwrite_existing`; if overwrite is disabled and target exists, ask user for replacement decision.
11. Effective instructions save/export/convert:
   - If `effective_instructions.export.auto_generate_on_scope_confirmed=true`, save compiled instructions automatically.
   - If user asks to save/export compiled/effective instructions, support directory bundle (canonical) or compact file.
   - Respect `effective_instructions.export.content_mode` (`reference|portable|hybrid`).
   - For `portable|hybrid`, include embedded content and warn about bigger artifacts and potential sensitive source sharing risk.
   - If user asks to convert bundle <-> compact, use the FDF conversion tool (path defined in conductor behavior).
   - Respect path policy from `effective_instructions.export.*`.

## checks
### scope
1. Scope boundaries are explicit.
2. Success criteria are measurable.
3. Imported candidate is validated (or invalid and replaced with compiled recommendation).
4. Imported compiled/effective instructions candidate is validated when provided.
5. Effective Rule Matrix is confirmed by user.
6. If auto-generation or user-requested matrix export is active, matrix export path is recorded.
7. If auto-generation or user-requested instructions export is active, instructions export path and format are recorded.
8. If export request wording is ambiguous (`state|compiled state`), clarification decision is captured before export.

## outputs
### scope
1. Scope summary.
2. Inferred context summary (including `context-model` fields, confidence, and evidence).
3. Matrix candidate source (`file|inline|none`) and validation result.
4. Compiled/effective instructions candidate source (`bundle|compact|none`) and validation result.
5. Selected profiles (if any) and profile overrides.
6. Confirmed Effective Rule Matrix as a markdown table (phase -> active rule ids).
7. Exported matrix path(s) when auto-generation or user-requested matrix export occurs.
8. Exported instructions path(s) and format(s) when auto-generation or user-requested instructions export occurs.
9. Clarification decision record when ambiguous export wording is used.
