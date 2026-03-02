# Rule: flow-observability

## id
`flow-observability`

## title
Flow Observability (Logging, Tracing, Persistence)

## tags
`observability`, `logging`, `tracing`, `persistence`, `team`

## applies_to_phases
`scope`, `explore`, `clarify`, `architect`, `implement`, `verify`, `summarize`

## intent
Persist the workflow state as versionable markdown files so teams can pause/resume asynchronously and debug the delivery process over time.

## guidance
### scope
1. Create a run directory using `references/persistence.md`:
   - `<run_root_dir>/<run_id>/`
2. Create baseline run files using templates:
   - `00-run.md` (use `../../templates/run-index.md`)
   - `01-scope.md` .. `07-summarize.md` (initial stubs are fine)
   - `decision-log.md`, `risk-register.md`, `open-questions.md`, `traceability.md`
   - `RUNBOOK.md` (when enabled by settings via `runbook-export`)
   - `state.json` (when enabled by settings via `state-export`)
   - `conversation-export.md` (when enabled by settings via `conversation-export`)
3. Record `selected_profiles`, `profile_overrides`, and the confirmed Effective Rule Matrix (compiled rules) in `00-run.md`.
4. For any user decision asked in Scope (including profiles/matrix), also create a team packet file under:
   - `<packets_dir>/01-scope-rule-matrix.md` (default `<packets_dir>`: `packets`; optional but recommended when async/team mode is likely)

### explore
1. Update `02-explore.md` with must-read files, runtime path map, and boundaries.
2. Update `traceability.md` with any new discovered surfaces.
3. Record any new risks or open questions in the shared logs.

### clarify
1. Update `03-clarify.md` with the clarified decisions, and remaining blocking questions.
2. If the user needs to answer asynchronously, create:
   - `<packets_dir>/03-clarify-questions.md` using `../../templates/packet-questions-tui.md`

### architect
1. Update `04-architect.md` with the options, recommendation, and selected option.
2. If the decision must be answered asynchronously, create:
   - `<packets_dir>/04-architect-option-choice.md` using `../../templates/packet-decision-tui.md`

### implement
1. Update `05-implement.md` with changed files summary, scope adherence notes, and any known gaps.
2. Keep `traceability.md` updated with requirement -> rule -> file/test links.

### verify
1. Update `06-verify.md` with findings, confidence, and disposition.
2. If disposition must be answered asynchronously, create:
   - `<packets_dir>/06-verify-disposition.md` using `../../templates/packet-decision-tui.md`

### summarize
1. Update `07-summarize.md` with the closure package and follow-ups.
2. Ensure shared logs reflect final state (risks closed/deferred, questions closed/deferred).

## checks
### scope
1. Run directory exists and is referenced in outputs.
2. `00-run.md` exists and includes provenance (profiles + compiled matrix).
3. `01-scope.md` is updated with the Scope output.

### explore
1. `02-explore.md` is updated and references concrete repo files.

### clarify
1. `03-clarify.md` records decisions and remaining blocking items.

### architect
1. `04-architect.md` includes options and the selected option.

### implement
1. `05-implement.md` records changed files and scope adherence.

### verify
1. `06-verify.md` records findings and disposition.

### summarize
1. `07-summarize.md` is complete and follow-ups are assigned.

## outputs
### scope
1. Run directory path and list of created files.
2. `00-run.md` updated provenance.

### explore
1. `02-explore.md` updated exploration record.

### clarify
1. `03-clarify.md` updated clarification record.

### architect
1. `04-architect.md` updated architecture record.

### implement
1. `05-implement.md` updated implementation record.

### verify
1. `06-verify.md` updated verification record.

### summarize
1. `07-summarize.md` updated closure record.
