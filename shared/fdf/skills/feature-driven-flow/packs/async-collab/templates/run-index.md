# FDF Run Index (00-run.md)

## Run Metadata

1. `run_id`:
2. `created_at`:
3. `feature_slug`:
4. `repo_root`:

## Request Snapshot

1. Request text:
2. Constraints:
3. Non-goals:

## Provenance

1. `AGENTS.md` constraints (summary):
2. `selected_profiles`:
3. `profile_overrides`:
4. Confirmed Effective Rule Matrix:

Formatting:
1. Keep one row per phase.
2. In "Active rules", use backticked rule ids separated by commas.
3. If this matrix is echoed in terminal/chat, do not render a table; use only a plain-text phase list.

| Phase | Active rules |
| --- | --- |
| scope | |
| explore | |
| clarify | |
| architect | |
| implement | |
| verify | |
| summarize | |

## Pointers

1. Phase files:
   - `01-scope.md` .. `07-summarize.md`
2. Cross-phase logs:
   - `decision-log.md`
   - `risk-register.md`
   - `open-questions.md`
   - `traceability.md`
   - `execution-metrics.md` (if used)
3. Team packets:
   - `<packets_dir>/` (default: `packets/`; if used)
