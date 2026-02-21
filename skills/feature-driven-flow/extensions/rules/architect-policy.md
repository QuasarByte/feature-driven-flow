# Rule: architect-policy

## id
`architect-policy`

## title
Architect Policy

## applies_to_phases
`architect`

## intent
Produce clear architecture choices with explicit tradeoffs and user selection.

## guidance
### architect
1. Run parallel `fdf-implementation-planner` passes where possible.
2. Produce at least three options: contained delta, seam-first modularization, delivery-optimized path.
3. Recommend one option with rationale.
4. Require explicit seams and clear component responsibilities in each option.
5. Include interface deltas, file-level implementation map, and delivery sequence.
6. Ask user to choose explicitly.

## checks
### architect
1. Tradeoffs are concrete.
2. Recommendation is justified.
3. Planning outputs are concrete (not generic) and tied to repository realities.
4. User-selected option is captured.

## outputs
### architect
1. Architecture options comparison.
2. Recommended path with rationale.
3. Repository constraints and conventions summary.
4. Component responsibilities and interface delta list.
5. File-by-file implementation map and ordered delivery sequence.
6. Recorded user choice.
