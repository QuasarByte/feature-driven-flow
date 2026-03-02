# FDF Runbook (RUNBOOK.md)

Purpose: resume this run on any machine, in any chat, and with any LLM/agent (Codex, Claude Code, Gemini CLI, etc.) using only the files in this directory.

## Quick Resume (Read Order)

1. Read `00-run.md` (provenance + confirmed Effective Rule Matrix).
2. Read the latest phase file (highest completed `0N-<phase>.md`).
3. Read shared logs:
   - `decision-log.md`
   - `open-questions.md`
   - `risk-register.md`
   - `traceability.md`
   - `execution-metrics.md` (if present)
4. Read any async packets under `<packets_dir>/` (default: `packets/`) and incorporate answers.
5. Continue at the next phase whose `gate_status` is `blocked` or not executed.

## Run Summary

1. `run_id`:
2. `feature_slug`:
3. Current phase:
4. Next action:

## How To Continue (Prompt Snippet)

Use a prompt like:

```text
Resume Feature-Driven-Flow from: <path-to-run-dir>

Read RUNBOOK.md, 00-run.md, the latest phase file, and shared logs.
Then continue at phase <N> with the confirmed Effective Rule Matrix and decisions.
```

## Cross-Agent Notes

1. Treat the confirmed Effective Rule Matrix in `00-run.md` as the execution plan.
2. Do not re-decide previous decisions unless new evidence requires it (record in `decision-log.md` and use `rule-matrix-diff.md` if changing rules).
3. Keep updates append-only or clearly versioned in markdown files to preserve auditability.
