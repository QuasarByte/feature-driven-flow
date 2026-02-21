# Rule: scope-baseline

## id
`scope-baseline`

## title
Scope Baseline

## applies_to_phases
`scope`

## intent
Establish shared understanding and lock the phase-by-phase rule matrix before execution.

## guidance
### scope
1. Restate desired outcome, scope boundaries, and success criteria.
2. Infer execution context using request text, repository signals, and `AGENTS.md`.
3. Propose a phase-by-phase rule matrix with one recommended baseline set.
4. Capture explicit user acceptance or edits to the matrix.

## checks
### scope
1. Scope boundaries are explicit.
2. Success criteria are measurable.
3. Rule matrix is confirmed by user.

## outputs
### scope
1. Scope summary.
2. Inferred context summary.
3. Confirmed phase-by-phase rule matrix.
