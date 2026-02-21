Run the feature-driven-flow workflow using the installed `feature-driven-flow` skill.

Task:
$ARGUMENTS

Requirements:
1. Execute all 7 phases in fixed order; do not skip or reorder phases, and honor phase gates/hard stops before advancing.
2. Keep core skeleton invariants intact (clarify gate, approval gate, verify-before-summary).
3. Infer execution context from request text, repository signals, and `AGENTS.md`.
4. In Scope, propose a phase-by-phase rule matrix with one recommended baseline set.
5. Ask user to accept or adjust rules before moving to Explore.
6. Apply rules per phase using extension precedence: selected shared rules, then applicable repository-local rules (including local baseline when present).
7. If rule guidance conflicts or is ambiguous, ask user to choose.
8. Treat `AGENTS.md` policy constraints as mandatory; if guidance conflicts, follow `AGENTS.md` and record the override.
9. Use specialist skills when selected rules require them:
   - `fdf-code-explorer`
   - `fdf-implementation-planner`
   - `fdf-change-auditor`
10. At every decision point, present numbered options, mark one as recommended, and ask the user to reply with a number or custom choice.
