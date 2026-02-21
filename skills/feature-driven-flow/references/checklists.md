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
4. Proposed phase-by-phase rule matrix recorded.
5. User confirmation or correction of rule matrix recorded.

## Rule Matrix Quality Checklist

1. Each selected rule is valid and available.
2. Each phase has explicit rule coverage.
3. Rule applicability matches `applies_to_phases`.
4. User-requested deviations from recommendations are recorded.
5. Rule changes after Scope are explicitly approved and logged.

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
