# Extensions

This directory provides rules-only customization for feature-driven-flow.

## Structure

1. `rules/`: reusable shared rules.

## How To Use

1. Start `/prompts:feature-driven-flow ...`.
2. Let Codex infer execution context.
3. Review the proposed phase-by-phase rule matrix.
4. Accept or adjust selected rules.
5. Run workflow with selected shared rules plus optional local rules.

## Local Rules

Repository-local rules are loaded from:

`<repo>/.codex/feature-driven-flow/rules/*.md`

Use `project-baseline.md` for always-on local policy.

## Notes

1. Rules are discovered from `extensions/rules/*.md` and optional local rule files.
2. One extension dimension is used: rules.
3. Rules are applied by phase based on each rule's `applies_to_phases`.
