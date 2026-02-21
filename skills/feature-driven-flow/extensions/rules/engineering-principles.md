# Rule: engineering-principles

## id
`engineering-principles`

## title
Engineering Principles

## applies_to_phases
`clarify`, `architect`, `implement`, `verify`

## intent
Keep delivery simple, maintainable, and aligned with KISS, DRY, SOLID, YAGNI, DDD, and TDD.

## guidance
### clarify
1. Confirm minimum viable scope.
2. Confirm domain language.

### architect
1. Favor clear responsibilities and seams.
2. Avoid speculative abstractions.
3. Prefer simplest reliable design.

### implement
1. Keep code readable and scoped.
2. Reduce harmful duplication.

### verify
1. Validate maintainability and coupling quality.
2. Validate test coverage for non-trivial behavior.

## checks
### clarify
1. Scope and terminology are explicit.

### architect
1. Design avoids unnecessary complexity.

### implement
1. Implementation matches principles in scope.

### verify
1. Violations are reported with severity and confidence.

## outputs
### clarify
1. Scope and terminology notes.

### architect
1. Principle alignment rationale.

### implement
1. Implementation notes showing how selected principles were applied.

### verify
1. Principle-alignment findings.
