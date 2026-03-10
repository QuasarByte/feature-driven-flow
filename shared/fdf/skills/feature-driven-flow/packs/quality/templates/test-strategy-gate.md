# Test Strategy Check Template

Use when `test-strategy-policy` is active (typically during Architect, before Implement).

## Active Rule Concerns

1. List concern areas required by active rules.
2. Include any repository-local concerns.

## Test Matrix

1. Unit tests:
   - critical functions
   - edge-case branches
2. Integration tests:
   - cross-module/cross-service flows
3. Regression tests:
   - previously stable behavior that must remain unchanged
4. Concern-focused tests:
   - derived from active rule concerns

## Exit Criteria

1. Required checks to proceed with implementation.
2. Mandatory pass criteria.
3. Known accepted gaps (if any).

