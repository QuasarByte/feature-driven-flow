# Rule: test-strategy-policy

## id
`test-strategy-policy`

## title
Test Strategy Policy

## tags
`testing`

## applies_to_phases
`architect`, `implement`

## intent
Define and enforce a concrete verification plan before and during implementation.

## guidance
### architect
1. Produce a test strategy using `../../templates/test-strategy-gate.md` before Implement.
2. Cover unit, integration, regression, and concern-focused tests.
3. Define pass criteria and blockers.

### implement
1. Execute planned checks where feasible.
2. Record test gaps explicitly when checks cannot run.

## checks
### architect
1. Test matrix is complete.
2. Pass criteria are explicit.

### implement
1. Executed checks are recorded.
2. Gaps and residual risk are documented.

## outputs
### architect
1. Completed test strategy gate.

### implement
1. Executed checks and results.
2. Test gaps and risk notes.

