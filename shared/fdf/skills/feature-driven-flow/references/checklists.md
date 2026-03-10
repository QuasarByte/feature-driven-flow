# Checklists

## Checklist Model

1. Core meta-checklists in this file always apply.
2. Phase checklists are derived from active rule `checks`.
3. For each phase, derived checklist = union of `checks` from rules where `applies_to_phases` includes that phase.
4. Record checklist results item-wise (`passed|blocked|n/a`) with evidence.
5. If any blocking checklist item is unresolved, phase `gate_status` must be `blocked`.

## Change Context Checklist

1. Change concerns required by active rules are recorded.
2. Relevant constraints and non-goals are listed clearly.
3. Inferred execution context recorded.
4. Context-model fields are recorded (strictness, change_type, system_shape, delivery_surface; plus optional compliance/flags) with evidence and confidence.
5. Matrix candidate input mode (`file|inline|none`) and source are recorded.
6. Compiled instructions candidate input mode (`bundle|compact|none`) and source are recorded.
7. Candidate validation result is recorded (or explicit fallback to profile-driven compilation).
8. Proposed phase-by-phase rule matrix recorded and shown as the Effective Rule Matrix.
9. If profiles are used: `selected_profiles` and `profile_overrides` are recorded next to the Effective Rule Matrix.
10. User confirmation or correction of the Effective Rule Matrix is recorded.
11. If settings are used: effective settings are recorded (defaults + overrides), with file path references.
12. If matrix export is auto-enabled or requested by user, exported path and outcome are recorded.
13. If compiled-instructions export is auto-enabled or requested by user, exported path, format, content mode, and outcome are recorded.

## Rule Matrix Quality Checklist

1. Each selected rule is valid and available.
2. Each phase has explicit rule coverage.
3. Rule applicability matches `applies_to_phases`.
4. User-requested deviations from recommendations are recorded.
5. Matrix rendering is markdown-safe in markdown files (native table, one row per phase, rule ids backticked and comma-separated in table cells).
6. Terminal/chat output does not render tables and uses only a plain-text phase list.
7. Imported candidates (if used) pass rule existence + phase applicability validation before acceptance.
8. Export path resolution follows settings/user override policy (default path, relative/absolute handling, overwrite policy).
9. Imported compiled-instructions candidates (if used) pass schema validation and embedded matrix checks before acceptance.
10. Content mode policy is respected (`reference|portable|hybrid`) and import mode is accepted by settings.
11. For portable/hybrid artifacts, user is warned about size and sensitive-content sharing risks.
12. Rule changes after Scope include an explicit before/after diff and are explicitly approved and logged.

## Persistence (When Enabled) Checklist

1. Run directory path is recorded.
2. Phase files exist (`01-...` through `07-...`) and match the executed phase order.
3. Cross-phase logs exist (`decision-log`, `risk-register`, `open-questions`, `traceability`).
4. If async packets are used, packet files exist and include options + answer fields.

## Cross-Phase Traceability Checklist

1. `decision_log` updated with decisions, rationale, and owner.
2. `risk_register` updated with severity, mitigation, and status.
3. `artifacts` list updated with produced templates/artifacts and references.
4. `traceability` map updated (requirement -> rules -> artifacts/files/tests).
5. `open_questions` explicitly carried forward or closed.

## Evidence Quality Checklist

1. Claims are backed by concrete evidence (files, outputs, tests, or tool results).
2. Assumptions are labeled and separated from verified facts.
3. Confidence and uncertainty are explicit where required.
4. Evidence links are sufficient for another reviewer to reproduce conclusions.

## Gate Integrity Checklist

1. `gate_status` is present for each phase.
2. If `blocked`, the blocking reason and unblock condition are recorded.
3. If `ready`, required outputs from active rules are complete.
4. Phase transitions are justified by recorded outputs and decisions.

## Derived Phase Checklist Execution

1. For each phase, compile checklist items from active rule `checks` that apply to the phase.
2. Add core invariant checks relevant to the phase:
   - explicit approval before Implement
   - decision-critical ambiguity resolved before leaving Clarify
   - Verify completed before Summarize
3. Execute checklist items and record results with evidence.
4. Record unresolved blocking items in `open_questions` and `risk_register`.
5. Set `gate_status` based on checklist outcome.

## Rule-Gated Artifact Checklist

1. If active rules require templates/artifacts, verify they are produced and referenced in `artifacts`.
2. If active rules require user decisions/disposition, verify they are recorded in `decision_log`.
3. If active rules require follow-up actions, verify owner and closure condition are recorded.

## Execution Metrics Checklist

1. Cycle time captured.
2. Clarify question count captured.
3. Rework/redo count captured.
4. Verify issue count and disposition summary captured.
5. Escaped test/operational gaps noted.
