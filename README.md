# Codex Feature-Driven-Flow

Script-free Codex package for one-command feature workflow orchestration with a rules-based extension system.
It is designed to keep feature delivery predictable by combining a minimal core workflow with declarative rules that can be shared or overridden per repository.

## Includes

1. Skills:
   - `skills/feature-driven-flow`: main conductor skill that drives the seven-phase workflow and gate checks.
   - `skills/fdf-code-explorer`: specialist skill for mapping current behavior and code paths before planning changes.
   - `skills/fdf-implementation-planner`: specialist skill for turning clarified requirements into a file-by-file implementation plan.
   - `skills/fdf-change-auditor`: specialist skill for reviewing completed changes, risks, and verification coverage.
2. Prompt:
   - `prompts/feature-driven-flow.md`: entrypoint that activates the conductor workflow in Codex.
3. Shared rules:
   - `skills/feature-driven-flow/extensions/rules/*.md`: reusable rule set for phase behavior, checks, and expected outputs.
4. Optional repository-local rules:
   - `<repo>/.codex/feature-driven-flow/rules/*.md`: local policy overlays that refine shared rules for a specific codebase.

## Install

1. Ensure Codex CLI works:
```text
codex --help
```
2. Resolve `CODEX_HOME`:
   - Windows default: `%USERPROFILE%\\.codex`
   - macOS/Linux default: `~/.codex`
3. Create folders:
   - `CODEX_HOME/skills`
   - `CODEX_HOME/prompts`
4. Copy package assets:
   - `codex/feature-driven-flow/skills/*` -> `CODEX_HOME/skills/`
   - `codex/feature-driven-flow/prompts/*.md` -> `CODEX_HOME/prompts/`
5. Restart Codex session so newly installed prompt and skills are detected.

## Use

Run the prompt:

```text
/prompts:feature-driven-flow Implement financial services
```

Select shared rules in the request to control phase behavior:

```text
/prompts:feature-driven-flow Implement financial services using rules scope-baseline, explore-baseline, clarify-policy, architect-policy, implement-baseline, verify-policy, summarize-policy, security-baseline
```

Repository-local baseline rule (auto-applied when present):

```text
<repo>/.codex/feature-driven-flow/rules/project-baseline.md
```

At Scope, Codex infers execution context and proposes a phase-by-phase rule matrix. The user can accept or adjust before Explore.
The workflow then proceeds through seven phases with explicit gates, checklist-based readiness, and approval points before implementation.

## Core vs Rules

Core is a light skeleton that enforces:

1. Seven-phase order.
2. Clarify-before-Architect/Implement gate.
3. Explicit approval before Implement.
4. Verify before Summarize.
5. Decision UX (numbered options with recommended default).
6. Checklist-driven gates where phase checklist items are derived from active rule `checks`.

Everything else should live in rules.
This separation keeps core behavior stable while allowing teams to evolve policy without editing conductor logic.

## Simple Rule Model

Each rule should define:

1. `id`: unique, stable rule identifier used in matrices and traceability.
2. `title`: short human-readable name.
3. `applies_to_phases`: one or more phases where the rule is active.
4. `intent`: what the rule is trying to guarantee.
5. `guidance`: concrete instructions Codex should follow when the rule is active.
6. `checks` (also used to derive phase checklist items): verifiable conditions that determine whether a phase can pass.
7. `outputs`: artifacts or structured results expected from the phase when the rule applies.
8. `examples` (optional)

## Rule Precedence

1. Core skeleton invariants.
2. Repository policy constraints in `AGENTS.md`.
3. User-confirmed phase-by-phase rule matrix.
4. Within active rules, repository-local rules refine shared rules.
   When instructions conflict, Codex should prioritize higher-precedence sources and ask for clarification if a conflict cannot be safely resolved.

## Diagnostics

1. If `codex` is not found, run `codex --help`.
2. If prompt does not appear, confirm `CODEX_HOME/prompts/feature-driven-flow.md` exists and restart.
3. If shared rules are not detected, check `CODEX_HOME/skills/feature-driven-flow/extensions/rules/`.
4. If local baseline rule is not applied, check `<repo>/.codex/feature-driven-flow/rules/project-baseline.md`.
5. If outputs look under-specified, include explicit rule IDs in your prompt instead of relying on defaults.
6. If a phase is blocked, inspect active rule `checks` first, then resolve missing inputs or approvals.

## Creator

- LinkedIn: https://www.linkedin.com/in/taluyev/
