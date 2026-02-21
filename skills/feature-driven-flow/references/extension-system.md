# Extension System

Use markdown rules to customize behavior without scripts.

## Goals

1. Keep core as a light workflow skeleton.
2. Move phase-specific behavior into selectable rules.
3. Keep behavior portable across Windows, macOS, and Linux.
4. Make phase execution auditable through rule-derived checklists.

## Layers and Precedence

Apply layers in this order:

1. Core skeleton (`SKILL.md`, `references/*`, `templates/*`).
2. Repository policy constraints in `AGENTS.md`.
3. User-confirmed phase-by-phase rule matrix (derived from inferred context).
4. Within active phase rules: selected shared rules, then applicable repository-local rules.

Conflict handling:

1. If rule guidance conflicts with core invariants or `AGENTS.md`, follow the higher layer and record the override.
2. If active rules disagree at the same layer, ask the user to choose.
3. Repository-local rules can refine shared rules when no higher-layer conflict exists.

## Rule Lifecycle

1. During Scope, infer execution context.
2. Propose a phase-by-phase rule matrix with one recommended baseline set.
3. Ask user to accept or adjust rule selections.
4. Apply selected shared rules.
5. Apply local baseline (`project-baseline.md`) and additional local rules when present.
6. For each phase, execute only rules whose `applies_to_phases` includes that phase.
7. Derive phase checklists from active rule `checks`.
8. Record checklist results and set phase `gate_status`.

## Rule Selection Quality

1. Ensure explicit rule coverage for each phase.
2. Keep rule selection minimal and purpose-driven; avoid redundant overlap.
3. Record any user-directed deviations from recommended rules.
4. If rule matrix changes after Scope, record explicit approval.

## Rule Applicability

1. Each rule declares `applies_to_phases`.
2. Only apply a rule in phases it declares.
3. Record applied rules by phase in outputs.
4. Derive phase checklists from active rule `checks`.

## Checklist and Gate Evaluation

1. Derived checklist for a phase is the union of `checks` from active phase rules.
2. Record each checklist item with `passed|blocked|n/a` and evidence.
3. If any blocking item is unresolved, phase `gate_status` is `blocked`.
4. Carry unresolved blocking items into `open_questions` and `risk_register`.
5. Phase transition requires `gate_status: ready`.

## Local Rule Governance

1. Load local rules from `.codex/feature-driven-flow/rules/*.md`.
2. Auto-apply `.codex/feature-driven-flow/rules/project-baseline.md` when present.
3. Treat missing local baseline as non-fatal; record that it was not found.
4. Keep local rules aligned to the same rule schema as shared rules.

## Failure Handling

1. If a selected rule id is missing or invalid, pause and ask user to choose a valid rule.
2. If rule text is ambiguous, request user confirmation before applying interpretation.
3. If rule guidance conflicts with core invariants, ignore conflicting guidance and record the reason.
4. If rule guidance conflicts with `AGENTS.md`, follow `AGENTS.md` and record the override.

## Allowed Rule Scope

Rules can define:

1. `intent`
2. `guidance`
3. `checks`
4. `outputs`
5. `examples` (optional)

Rules must not override:

1. Seven-phase order.
2. Explicit approval before Implement.
3. Verify-before-Summarize requirement.
4. Decision UX requirement.
