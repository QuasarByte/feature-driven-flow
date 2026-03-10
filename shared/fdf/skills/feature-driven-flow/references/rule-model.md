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
2. `tags`: categorization hints, primarily *concern* tags (quality/risk surface).
   Canonical concerns (recommended):
   - `security`
   - `performance`
   - `operations`
   - `release`
   - `testing`
   - `compatibility`
   - `observability`
   - `persistence`
   - `settings`
   - `packs`
   - plus phase/process tags like `process`, `scope`, `explore`, `clarify`, `architect`, `implement`, `verify`, `summarize`
3. `requires`: optional list of rule ids that should also be selected when this rule is selected.
4. `conflicts_with`: optional list of rule ids that should not be selected together with this rule.

## Authoring Notes

1. Keep rule instructions specific and concise.
2. Keep behavior phase-scoped; avoid cross-phase hidden requirements.
3. If a rule introduces a blocking condition, state it explicitly in `checks`.
4. Prefer additive guidance; use user confirmation when direction is ambiguous.
5. Write `checks` as clear, verifiable checklist items.
6. Keep `requires`/`conflicts_with` lists small and obvious; if the relationship is non-trivial, require an explicit user decision.
