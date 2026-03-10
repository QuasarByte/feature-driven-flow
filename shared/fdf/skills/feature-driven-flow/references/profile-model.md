# Profile Model

Profiles are reusable policy bundles that select rules and compile down to an explicit phase-by-phase rule matrix.

This keeps execution auditable and stable:

* profiles are inputs
* the compiled rule matrix is the canonical execution plan
* present this plan to users as the "Effective Rule Matrix"

## Profile File Schema (Markdown)

Each profile file should follow this lightweight schema.

## Required Fields

1. `id`: stable identifier used in prompts and provenance.
2. `title`: readable name.
3. `intent`: why this profile exists and when to use it.
4. `rule_sets`: how rules are selected (see below).

## Optional Fields

1. `extends`: base profile id(s) to inherit from (use sparingly).
2. `constraints`: compatibility rules, mutual exclusions, or notes that influence compilation.
3. `outputs_expectations`: templates/artifacts typically expected when this profile is active.
4. `examples`: example requests and recommended overlays.

Omit optional sections when unused.

## rule_sets

`rule_sets` organizes which rules get selected.

1. `always`: list of rule ids that are always selected.
2. `by_phase`: optional per-phase list of rule ids to add.
3. `optional_overlays`: optional list of overlay profile ids suggested (not auto-applied).

## Compilation (Profiles -> Rule Matrix)

Given:

* inferred execution context (evidence-backed)
* selected profile(s): one base + zero or more overlays
* explicit per-phase overrides (optional)

Compilation produces:

* `selected_profiles`: the base + overlay list in applied order
* `profile_overrides`: explicit edits and rationale (if any)
* `rule_matrix`: mapping `phase -> [rule_id...]` (shown to users as the Effective Rule Matrix)

Recommended compilation algorithm:

1. Start with base profile `rule_sets`.
2. Apply overlays in user-specified order (record the order).
3. Expand selected rules across phases using each rule's `applies_to_phases`.
4. Apply `by_phase` additions (validate that the rule applies to that phase).
5. Apply explicit user overrides (adds/removals) per phase.
6. Validate the resulting matrix:
   - every referenced rule id exists
   - each phase has explicit rule coverage
   - matrix entries match each rule's `applies_to_phases`
   - constraints/mutual exclusions are satisfied
7. Present the compiled matrix as the Effective Rule Matrix for explicit user confirmation before proceeding to Explore.
   In markdown files, render it as a native markdown table with one row per phase; in each rules cell, use backticked rule ids separated by commas.
   In terminal/chat output, do not render a table; render only a plain-text phase list.

## Reuse via Imported Matrix

At Scope, users may provide a precomputed matrix candidate (file path or inline block).

1. Normalize imported data into the canonical `rule_matrix` structure.
2. Validate imported rule IDs and phase applicability against active assets.
3. If validation fails, either fix via user-approved edits or fall back to profile-driven compilation.
4. Even when import succeeds, require explicit user confirmation before leaving Scope.

## Reuse via Imported Compiled Instructions

At Scope, users may provide precompiled instructions as:

1. directory bundle, or
2. compact file.

Guidance:

1. Validate imported artifact schema first.
2. Validate embedded matrix and phase coverage.
3. Validate content mode and import policy compatibility (`reference|portable|hybrid`).
4. Treat imported compiled instructions as candidate guidance, not an invariant override.
5. If imported guidance drifts from active assets, ask user to accept, refresh, or discard before proceeding.

## Precedence

Profiles do not override higher layers.

1. Core skeleton invariants (non-overridable)
2. `AGENTS.md` (mandatory)
3. Profile selection + explicit overrides (optional inputs)
4. Compiled/confirmed Effective Rule Matrix (canonical execution plan; stored as `rule_matrix`)
5. Phase execution: shared rules then local rules

## Composition Model (Deterministic)

1. Exactly one base profile.
2. Zero or more overlay profiles.
3. Conflicts at the same layer require an explicit user decision.
4. Conflicts with core invariants or `AGENTS.md` must be resolved in favor of the higher layer and recorded as an override.

## Conventions: Strictness and Concerns

Recommended interpretation:

1. Base profiles represent a `strictness` level (governance weight):
   - `lean`
   - `baseline`
   - `hardened`
2. Overlay profiles represent a `concern` (quality/risk surface):
   - `security`, `performance`, `operations`, `release`, `testing`, `compatibility`, etc.

Strictness and concerns should compile to the same canonical artifact:

* the confirmed Effective Rule Matrix (phase-by-phase rules)
