# Phase Contracts

## Input Contract

1. Feature request text.
2. Project root path.
3. Constraints.
4. Non-goals.
5. Change concerns required by active rules.
6. Rule selection context:
   - inferred execution context summary and confidence
   - selected shared rules
   - selected repository-local rules
   - user confirmation or adjustment of phase rule matrix

## Output Contract by Phase

1. Scope:
   - outputs defined by active Scope-phase rules
2. Explore:
   - outputs defined by active Explore-phase rules
3. Clarify:
   - outputs defined by active Clarify-phase rules
4. Architect:
   - outputs defined by active Architect-phase rules
5. Implement:
   - outputs defined by active Implement-phase rules
6. Verify:
   - outputs defined by active Verify-phase rules
7. Summarize:
   - outputs defined by active Summarize-phase rules

## Structured Output Requirement

Each phase response should include this lightweight structure:

1. `phase`: phase name.
2. `inputs`: key context used.
3. `outputs`: phase-specific results.
4. `applied_rules`: rules applied in this phase.
5. `checklist_results`: derived checklist items from active rule `checks`, with `passed|blocked|n/a` and evidence.
6. `decision_log`: decisions made, rationale, owner.
7. `risk_register`: active risks, severity, mitigation, status.
8. `artifacts`: templates or artifacts produced in this phase.
9. `traceability`: requirement -> rules -> artifacts/files/tests mapping.
10. `open_questions`: unresolved items, if any.
11. `gate_status`: `blocked|ready`.

## Hard Stop Conditions

1. Missing user approval for implementation.
2. Open critical ambiguity in requirements.
3. Verify phase not performed.
