# Extension System

Use markdown rules to customize behavior without scripts.

## Goals

1. Keep core as a light workflow skeleton.
2. Move phase-specific behavior into selectable rules.
3. Keep behavior portable across Windows, macOS, and Linux.
4. Make phase execution auditable through rule-derived checklists.
5. Enable reusable policy bundles (profiles) that compile down to an explicit rule matrix (shown to users as the Effective Rule Matrix).
6. Support persistence and async team handoff via versionable markdown artifacts.
7. Support repository-local settings to avoid hardcoded paths/modes in rule text.
8. Support pack bundles (rules/profiles/templates/references) for "repositories of repositories".
9. Support reusable compiled-instructions artifacts (directory bundle + compact) for cross-agent portability.

## Layers and Precedence

Apply layers in this order:

1. Core skeleton (`SKILL.md`, `references/*`, `templates/*`).
2. Repository policy constraints in `AGENTS.md`.
3. Settings and pack selection (`settings.json`, repo-local settings, enabled packs).
4. Profile selection + explicit overrides (inputs; optional).
5. User-confirmed Effective Rule Matrix (compiled phase-by-phase rules derived from inferred context and optional profiles).
6. Within active phase rules: core shared rules + enabled pack rules, then applicable repository-local rules.

Conflict handling:

1. If rule guidance conflicts with core invariants or `AGENTS.md`, follow the higher layer and record the override.
2. If active rules disagree at the same layer, ask the user to choose.
3. Repository-local rules can refine shared rules when no higher-layer conflict exists.

## Rule Lifecycle

1. During Scope, infer execution context.
2. If user provides Effective Rule Matrix candidate (file path or inline block), parse and validate it first.
3. If user provides Effective Instructions candidate (directory bundle or compact file), parse and validate it first.
4. If matrix candidate is missing or invalid, propose a profile selection (base + optional overlays) with one recommended baseline set.
5. Compile selected profile(s) when needed, or normalize the imported candidate, into the canonical phase-by-phase matrix.
6. Present the result as the Effective Rule Matrix and ask user to accept or adjust it.
7. Export/save the confirmed matrix when requested by user or when `matrix_export.auto_generate_on_scope_confirmed=true`.
8. Export/save compiled instructions (bundle or compact) when requested by user or when `effective_instructions.export.auto_generate_on_scope_confirmed=true`.
   Support content mode `reference|portable|hybrid` according to settings and user instruction.
9. Resolve active rule assets from core + enabled packs.
10. Apply local baseline (`project-baseline.md`) and additional local rules when present and enabled.
11. For each phase, execute only rules whose `applies_to_phases` includes that phase.
12. Derive phase checklists from active rule `checks`.
13. Record checklist results and set phase `gate_status`.

## Rule Selection Quality

1. Ensure explicit rule coverage for each phase.
2. Keep rule selection minimal and purpose-driven; avoid redundant overlap.
3. Record any user-directed deviations from recommended rules.
4. If rule matrix changes after Scope, show a before/after diff, and record explicit approval.

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

## Profiles (Optional Selection Mechanism)

Profiles are reusable policy bundles that select rules. They do not change runtime execution behavior directly.

1. Profiles compile down to the same canonical artifact used today: a phase-by-phase rule matrix.
2. The compiled matrix is what is confirmed by the user and used for phase execution and checklist derivation.
3. Profiles should be recorded as provenance alongside the matrix:
   - `selected_profiles`
   - `profile_overrides` (if any)
4. Shared profiles can be discovered from `extensions/profiles/*.md`.
5. Repository-local profiles (optional) can be loaded from `.codex/feature-driven-flow/profiles/*.md`.

See `references/profile-model.md` for the profile schema and merge rules.
See `references/effective-instructions-reuse.md` for compiled-instructions bundle/compact behavior.

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
