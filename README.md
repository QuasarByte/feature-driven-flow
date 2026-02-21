# Codex Feature-Driven-Flow

Script-free Codex package for one-command feature workflow orchestration with a rules-based extension system.

## Includes

1. Skills:
   - `skills/feature-driven-flow`
   - `skills/fdf-code-explorer`
   - `skills/fdf-implementation-planner`
   - `skills/fdf-change-auditor`
2. Prompt:
   - `prompts/feature-driven-flow.md`
3. Shared rules:
   - `skills/feature-driven-flow/extensions/rules/*.md`
4. Optional repository-local rules:
   - `<repo>/.codex/feature-driven-flow/rules/*.md`

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
4. Copy:
   - `codex/feature-driven-flow/skills/*` -> `CODEX_HOME/skills/`
   - `codex/feature-driven-flow/prompts/*.md` -> `CODEX_HOME/prompts/`
5. Restart Codex session.

## Use

Run the prompt:

```text
/prompts:feature-driven-flow Implement financial services
```

Select shared rules in the request:

```text
/prompts:feature-driven-flow Implement financial services using rules scope-baseline, explore-baseline, clarify-policy, architect-policy, implement-baseline, verify-policy, summarize-policy, security-baseline
```

Repository-local baseline rule (auto-applied when present):

```text
<repo>/.codex/feature-driven-flow/rules/project-baseline.md
```

At Scope, Codex infers execution context and proposes a phase-by-phase rule matrix. The user can accept or adjust before Explore.

## Core vs Rules

Core is a light skeleton that enforces:

1. Seven-phase order.
2. Clarify-before-Architect/Implement gate.
3. Explicit approval before Implement.
4. Verify before Summarize.
5. Decision UX (numbered options with recommended default).
6. Checklist-driven gates where phase checklist items are derived from active rule `checks`.

Everything else should live in rules.

## Simple Rule Model

Each rule should define:

1. `id`
2. `title`
3. `applies_to_phases`
4. `intent`
5. `guidance`
6. `checks` (also used to derive phase checklist items)
7. `outputs`
8. `examples` (optional)

## Rule Precedence

1. Core skeleton invariants.
2. Repository policy constraints in `AGENTS.md`.
3. User-confirmed phase-by-phase rule matrix.
4. Within active rules, repository-local rules refine shared rules.

## Diagnostics

1. If `codex` is not found, run `codex --help`.
2. If prompt does not appear, confirm `CODEX_HOME/prompts/feature-driven-flow.md` exists and restart.
3. If shared rules are not detected, check `CODEX_HOME/skills/feature-driven-flow/extensions/rules/`.
4. If local baseline rule is not applied, check `<repo>/.codex/feature-driven-flow/rules/project-baseline.md`.
