---
name: feature-driven-flow
description: Coordinate a structured 7-phase feature delivery workflow in Codex for non-trivial work. Use when a task needs scoped intent, repository behavior tracing, ambiguity resolution, design choices, controlled implementation, assurance, and end-state reporting.
---

# Feature-Driven-Flow Conductor

Execute feature delivery in seven phases with explicit checkpoints.

## Workflow Contract

1. Run Phase 1 Scope.
2. Run Phase 2 Explore.
3. Run Phase 3 Clarify.
4. Run Phase 4 Architect.
5. Run Phase 5 Implement.
6. Run Phase 6 Verify.
7. Run Phase 7 Summarize.

Read `references/phase-contracts.md` before running phases.
Read `references/checklists.md` before finalizing.
Read `references/extension-system.md` and `references/rule-model.md` before applying rules.

## Core Skeleton Invariants

1. Do not change phase order.
2. Do not begin Implement without explicit user approval.
3. Do not leave Clarify while decision-critical ambiguity remains unresolved.
4. Do not close workflow before Verify disposition and final Summarize output.

## Interactive Decision UX

1. When a user decision is needed, provide 2-4 numbered options.
2. Mark one option as recommended and include a one-line rationale/tradeoff.
3. Ask the user to reply with the option number or a custom answer.
4. Do not move forward until the decision is explicitly captured.

## Rule System

1. Use one extension dimension: rules.
2. Infer execution context from request text, repository signals, and `AGENTS.md`.
3. In Scope, propose a phase-by-phase rule matrix with a recommended baseline set.
4. Ask user to accept or adjust the proposed rule matrix before Explore.
5. Apply rules in this order:
   - selected shared rules in `extensions/rules/*.md`
   - repository-local rules in `.codex/feature-driven-flow/rules/*.md`
6. If rules disagree, ask user which direction to follow.
7. `AGENTS.md` policy constraints remain mandatory.

## Phase Skeleton

### Phase 1 Scope

1. Open a phase tracker for all seven phases.
2. Execute active Scope-phase rules.
3. Capture user-confirmed rule matrix before Phase 2.

### Phase 2 Explore

1. Execute active Explore-phase rules.

### Phase 3 Clarify

1. Execute active Clarify-phase rules.

### Phase 4 Architect

1. Execute active Architect-phase rules.

### Phase 5 Implement

1. Confirm explicit approval.
2. Execute active Implement-phase rules.

### Phase 6 Verify

1. Execute active Verify-phase rules.

### Phase 7 Summarize

1. Execute active Summarize-phase rules.
2. Close phase tracker.

## Output Templates

Use templates in:

1. `templates/clarifying-questions.md`
2. `templates/architecture-options.md`
3. `templates/review-report.md`
4. `templates/structured-phase-output.md`
5. `templates/test-strategy-gate.md`
6. `templates/release-readiness-gate.md`
7. `templates/execution-metrics.md`
8. `extensions/rules/*.md`
9. `.codex/feature-driven-flow/rules/*.md` (when present)

## Tooling Expectations

1. Prefer fast file search and targeted reads.
2. Keep outputs concise but complete.
3. Enforce phase checkpoints through explicit outputs and decisions.
