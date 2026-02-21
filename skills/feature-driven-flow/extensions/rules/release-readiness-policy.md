# Rule: release-readiness-policy

## id
`release-readiness-policy`

## title
Release Readiness Policy

## applies_to_phases
`verify`, `summarize`

## intent
Ensure deploy-impacting changes have explicit go/no-go readiness.

## guidance
### verify
1. When release behavior changes, produce `../../templates/release-readiness-gate.md`.
2. Validate rollout, rollback, observability, and migration concerns.
3. Capture go/no-go recommendation and rationale.

### summarize
1. Include final release readiness disposition and follow-up actions.

## checks
### verify
1. Release readiness gate is completed when applicable.
2. Go/no-go decision is explicit.

### summarize
1. Follow-up actions are assigned.

## outputs
### verify
1. Completed release readiness gate.
2. Go/no-go recommendation.

### summarize
1. Final release disposition and next actions.
