# Release Readiness Check Template

Use when `release-readiness-policy` is active and release behavior changes (typically in Verify, then carried into Summarize).
If a section does not apply, mark it `N/A` and include a short reason.

## Rollout Plan

1. Release/deployment order (if applicable).
2. Feature flags/toggles or staged activation plan (if applicable).
3. Blast-radius mitigation and owner.

## Rollback Plan

1. Rollback trigger conditions.
2. Rollback or disablement steps.
3. Data rollback/backfill considerations (if applicable).

## Observability and Operations

1. Metrics/signals to watch (if applicable).
2. Logs/traces required for diagnosis (if applicable).
3. Alerts and thresholds (if applicable).

## Compatibility and Migration

1. Backward compatibility status.
2. Migration status (schema/config/protocol, if applicable).
3. Remaining concerns.

## Decision

1. `go` or `no-go`
2. Rationale
3. Required follow-up actions
