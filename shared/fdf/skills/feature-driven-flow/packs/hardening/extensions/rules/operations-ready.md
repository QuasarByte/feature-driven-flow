# Rule: operations-ready

## id
`operations-ready`

## title
Operations Ready

## tags
`operations`

## applies_to_phases
`explore`, `clarify`, `architect`, `verify`

## intent
Ensure deployable changes are operable and supportable in production.

## guidance
### explore
1. Identify operational dependencies, runtime jobs, and handoff points.
2. Identify current telemetry/diagnostics surfaces relevant to the change area.
3. Identify likely failure-isolation boundaries.

### clarify
1. Capture rollout constraints and freeze windows.
2. Capture alert ownership and escalation.
3. Capture on-call expectations.

### architect
1. Define staged rollout strategy.
2. Define failure isolation strategy.
3. Define rollback/recovery approach.

### verify
1. Validate operational checklist completeness.
2. Validate observability signal coverage.
3. Validate runbook and handoff completeness.

## checks
### explore
1. Operational dependencies and diagnostics surfaces are mapped.

### clarify
1. Operational ownership is assigned.

### architect
1. Recovery path is explicit.

### verify
1. Operational gaps are identified before closure.

## outputs
### explore
1. Operations-focused behavior map notes.

### clarify
1. Ops constraint and ownership notes.

### architect
1. Rollout/recovery design notes.

### verify
1. Operations readiness findings.

