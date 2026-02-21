# Rule Model

Use this lightweight schema for every rule file.

## Required Fields

1. `id`: stable identifier used in prompts.
2. `title`: readable name.
3. `applies_to_phases`: list of phases where rule applies.
4. `intent`: why this rule exists.
5. `guidance`: what to do in each applicable phase.
6. `checks`: what to verify in each applicable phase (also used as phase checklist items).
7. `outputs`: what to include in phase outputs.

## Optional Field

1. `examples`: concrete prompt/usage examples.

## Authoring Notes

1. Keep rule instructions specific and concise.
2. Keep behavior phase-scoped; avoid cross-phase hidden requirements.
3. If a rule introduces a blocking condition, state it explicitly in `checks`.
4. Prefer additive guidance; use user confirmation when direction is ambiguous.
5. Write `checks` as clear, verifiable checklist items.
