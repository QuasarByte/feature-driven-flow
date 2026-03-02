# Structured Phase Output Template

Use this shape for every phase response.

## Phase Header

1. `phase`: `<scope|explore|clarify|architect|implement|verify|summarize>`
2. `gate_status`: `<ready|blocked>`

## Inputs

1. Key request/context used.
2. Prior phase outputs referenced.
3. If applicable: `selected_profiles` and `profile_overrides` referenced from Scope.
4. If Scope: matrix candidate input mode (`file|inline|none`), source, and validation result.
5. If Scope: compiled instructions candidate mode (`bundle|compact|none`), content mode (`reference|portable|hybrid|none`), source, and validation result.
6. If Scope: imported custom instructions disposition (`accept|edit|discard|none`) and confirmation state.
7. If Scope: matrix export mode (`auto|on-demand|none`) and target path selection.
8. If Scope: compiled instructions export mode (`auto|on-demand|none`), output format (`bundle|compact`), and content mode (`reference|portable|hybrid`).
9. If Scope: custom instructions export decision (`include|skip`), approval status (`approved|pending|none`), and approved/skipped counts.

## Outputs

1. Main results for this phase.
2. Decisions made in this phase.
3. Artifacts/templates produced.
4. If applicable: matrix export status and exported path(s).
5. If applicable: compiled instructions export status, format, content mode, and exported path(s).
6. If applicable: custom instructions export status, decision, and approved/skipped item counts.

## Applied Rules

1. Rules applied in this phase.
2. Notes on any user-directed rule overrides.

## Checklist Results

1. Derived checklist item from active rule `checks`.
2. Result: `passed|blocked|n/a`.
3. Evidence/reference.

## Decision Log

1. Decision made.
2. Rationale.
3. Owner.
4. If export intent was ambiguous (`state|compiled state`), record the chosen interpretation (Effective Rule Matrix vs Effective Instructions vs `state.json`).

## Risk Register

1. Active risk.
2. Severity.
3. Mitigation.
4. Status.

## Artifacts

1. Template or artifact name.
2. Location or reference.

## Traceability

1. Requirement.
2. Rule(s) applied.
3. Artifact/file/test evidence.

## Open Questions

1. Remaining unresolved items.
2. Owner for each unresolved item.
