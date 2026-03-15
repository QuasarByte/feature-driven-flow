# Persistence and Team Handoff (Run Directory Convention)

Goal: make Feature-Driven-Flow usable asynchronously (team, email/messenger, days/weeks pauses) by persisting phase outputs and decisions as versionable markdown files.

This is implemented as rule-driven behavior (see `../extensions/rules/flow-observability.md` and `../extensions/rules/async-decision-packets.md`).

## Run Directory

When persistence is enabled, create a run directory under the target repository root:

`<run_root_dir>/<run_id>/`

`<run_root_dir>` default is `fdf/runs` and may be overridden by settings:

`persistence.run_root_dir`

`<run_id>` convention (recommended):

`YYYYMMDD-HHMM-<short-slug>`

Example:

`fdf/runs/20260301-1542-auth-refresh/`

## File Naming (Phase Order + Phase Name)

Use numeric prefixes to preserve phase order in file listings:

1. `00-run.md` (index + provenance)
2. `01-scope.md`
3. `02-explore.md`
4. `03-clarify.md`
5. `04-architect.md`
6. `05-implement.md`
7. `06-verify.md`
8. `07-summarize.md`

Shared cross-phase logs:

1. `decision-log.md`
2. `risk-register.md`
3. `open-questions.md`
4. `traceability.md`
5. `execution-metrics.md` (optional; can reuse `../../../templates/execution-metrics.md`)

Portability exports (optional; controlled by settings):

1. `RUNBOOK.md`
2. `state.json`
3. `conversation-export.md`

Team async packets:

`<packets_dir>/`

`<packets_dir>` default is `packets` and may be overridden by settings:

`async_packets.dir`

Example filenames:

1. `packets/01-scope-rule-matrix.md`
2. `packets/03-clarify-questions.md`
3. `packets/04-architect-option-choice.md`
4. `packets/06-verify-disposition.md`

## Resume Rules (Human + Agent)

1. To resume after a pause, read `00-run.md` first, then the latest phase file, then the shared logs.
2. Treat the run directory as the source of truth for:
   - selected profiles and confirmed Effective Rule Matrix (compiled rule matrix)
   - decisions already made
   - open questions and owners
   - risks and mitigations
3. If new facts require changing the rule matrix after Scope, use `../../../templates/rule-matrix-diff.md` and record explicit approval.

