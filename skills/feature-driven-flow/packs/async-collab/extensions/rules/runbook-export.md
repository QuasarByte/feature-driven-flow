# Rule: runbook-export

## id
`runbook-export`

## title
Runbook Export (Cross-Agent Resume)

## tags
`persistence`, `portability`, `team`

## applies_to_phases
`scope`, `summarize`

## intent
Create a human- and agent-readable `RUNBOOK.md` in the run directory so the run can be resumed on other machines and with other LLM/agent tools.

## guidance
### scope
1. If persistence is enabled, create or update:
   - `<run_root_dir>/<run_id>/<exports.runbook.filename>` using `../../templates/runbook.md` (default: `RUNBOOK.md`)
2. Ensure it includes:
   - run id
   - current phase
   - resume read-order
   - prompt snippet for resuming in other tools

### summarize
1. Update `RUNBOOK.md` with final phase state and closure disposition.

## checks
### scope
1. `RUNBOOK.md` exists under the run directory when persistence is enabled.

### summarize
1. `RUNBOOK.md` reflects final state and next actions (if any).

## outputs
### scope
1. Runbook path.

### summarize
1. Updated runbook path.
