# Rule: state-export

## id
`state-export`

## title
State Export (state.json)

## tags
`persistence`, `portability`, `state`

## applies_to_phases
`scope`, `clarify`, `architect`, `implement`, `verify`, `summarize`

## intent
Export a minimal machine-readable snapshot of the run state for cross-agent portability (tools that prefer structured inputs).

## guidance
### scope
1. If persistence is enabled and `exports.state_json.enabled=true`, create:
   - `<run_root_dir>/<run_id>/<exports.state_json.filename>` using `../../templates/state.json` (default: `state.json`)
2. Populate at minimum:
   - `run_id`, `created_at`, `repo_root`, `feature_slug`
   - `selected_profiles`, `profile_overrides`
   - compiled `rule_matrix`
   - `settings` (effective settings)

### clarify
1. Update `state.json` with new decisions, open questions, and current phase.

### architect
1. Update `state.json` with selected architecture option decision and current phase.

### implement
1. Update `state.json` with changed files summary decision entry (high-level) and current phase.

### verify
1. Update `state.json` with disposition decision and current phase.

### summarize
1. Update `state.json` with final status and any follow-up decisions.

## checks
### scope
1. `state.json` exists when persistence enabled and state export enabled by settings.

### summarize
1. `state.json` reflects final state.

## outputs
### scope
1. State export path.

### summarize
1. Updated state export path.
