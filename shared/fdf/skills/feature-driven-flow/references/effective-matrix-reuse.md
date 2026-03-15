# Effective Matrix Reuse

This document defines how users can reuse a precomputed Effective Rule Matrix at Scope to save tokens and keep behavior consistent across sessions.

## Core Principle

1. Imported matrix data is a candidate input.
2. The run still requires validation + explicit user confirmation in Scope.
3. Core invariants and `AGENTS.md` constraints still take precedence.
4. Export/save behavior is controlled by `matrix_export.*` settings; auto-generation is optional and disabled by default.
5. Compiled/effective instructions reuse is covered separately in `effective-instructions-reuse.md`.

## Supported Input Modes

### 1) File Path Input

User supplies a path to a JSON artifact (recommended):

`<repo>/.codex/feature-driven-flow/effective-rule-matrix.json`

Artifact must conform to:

`../../../schemas/fdf-effective-matrix.schema.json`

### 2) Inline Multiline Block Input

User pastes a multiline block directly in prompt/chat.

Accepted inline forms:

1. Fenced JSON that conforms to the effective matrix schema.
2. Plain phase list in this shape:
   - `scope: rule-a, rule-b`
   - `explore: rule-c`
   - ...

If inline text is not canonical JSON, normalize it into the canonical `rule_matrix` structure before validation.

## Canonical Artifact Fields

Required fields:

1. `schema` (`fdf/effective-rule-matrix.v1`)
2. `fdf_version`
3. `created_at`
4. `selected_profiles`
5. `profile_overrides`
6. `enabled_packs`
7. `rule_matrix` (`phase -> [rule_id...]`)

Optional fields:

1. `context_model`
2. `notes`

## Scope Validation Checklist (Imported Matrix)

1. All 7 phases are present in `rule_matrix`.
2. Every referenced rule ID exists in enabled core/pack/local assets.
3. Rule applicability matches phase (`applies_to_phases`).
4. Matrix does not violate core invariants or `AGENTS.md`.
5. If candidate differs from recommended compilation, show diff and ask user disposition.

## Decision Flow

1. Parse candidate (file or inline block).
2. Normalize to canonical matrix model.
3. Validate candidate against active asset set and constraints.
4. Present:
   - validation result
   - normalized matrix
   - diff vs recommended matrix (if applicable)
5. Ask user:
   - accept imported matrix
   - adjust imported matrix
   - discard and use recommended compilation

## Import Interpretation Hints

Treat the following as equivalent import intent:

1. "load matrix"
2. "import matrix"
3. "use matrix"
4. "read matrix"
5. "reuse matrix"

Input resolution:

1. If prompt includes a path, treat it as file-path import candidate.
2. If prompt includes a multiline matrix block, treat it as inline import candidate.
3. If user asks to load/import matrix but gives no path or block, ask for one of:
   - path to matrix file, or
   - inline matrix block.

## Export / Save Behavior

Users may ask to save the active matrix for future runs.

Interpretation hints:

1. Treat "save/export current matrix", "save/export active matrix", "save/export chosen matrix", "save/export current choice", "save/export effective matrix", and "save/export compiled matrix" as equivalent requests.
2. "Current matrix" means the currently confirmed Effective Rule Matrix for this run.

Ambiguous terms:

1. If user asks only for "state" or "compiled state", do not assume intent.
2. Ask a short clarification:
   - export Effective Rule Matrix, or
   - export Effective Instructions, or
   - export run `state.json`.
3. After clarification, proceed using normal path resolution and export policy.

Path resolution:

1. If user provides path and `matrix_export.allow_user_path_override=true`, use that path.
2. Otherwise use `matrix_export.default_file`.
3. Relative paths resolve from repository root.
4. Absolute paths are allowed only when `matrix_export.allow_absolute_path=true`.
5. If `matrix_export.overwrite_existing=false` and target exists, ask user before replacing.

Auto-generation:

1. If `matrix_export.auto_generate_on_scope_confirmed=true`, save matrix immediately after Scope confirmation.
2. If auto-generation is disabled, save only on explicit user request.

## Output Requirements

In Scope outputs record:

1. matrix input mode (`file|inline|none`)
2. matrix source reference (path or "inline block")
3. validation result (`passed|failed`) with evidence
4. confirmed Effective Rule Matrix (after any edits)
5. matrix provenance fields (`selected_profiles`, `profile_overrides`, `enabled_packs`)
6. exported matrix path(s), when auto-generated or user-requested
