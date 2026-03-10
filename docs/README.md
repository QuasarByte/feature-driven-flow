# Documentation Map

Use this directory as a set of focused documents, not one linear manual.

## Read Order

1. `fdf-cross-agent-architecture.md`
   Read this first when you need repository layout, packaging model, and agent parity.
2. `specification.md`
   Read this for runtime behavior, artifact contracts, precedence, and customization rules.
3. `validation-types-playbook.md`
   Read this when changing assets, scripts, manifests, or release packaging.
4. `distribution/claude-feature-driven-flow-repo-spec.md`
   Read this only when preparing or auditing the Claude marketplace repository.

## Platform References

These documents are useful background for Claude plugin mechanics, but they are not the source of truth for this repository's FDF behavior:

1. `platform/claude-code/plugin-components-reference.md`
2. `platform/claude-code/plugin-manifest-reference.md`

When a platform reference conflicts with an FDF repo doc:

1. The platform reference explains Claude capabilities.
2. The FDF repo docs explain how this repository chooses to use those capabilities.

## Boundaries

Keep these responsibilities separate:

1. Architecture
   Source layout, shared-vs-wrapper assets, packaging targets, install model.
2. Specification
   Phases, rules, profiles, artifacts, settings, precedence, persistence.
3. Validation
   Operational checks, failure triage, release gates.
4. Distribution spec
   Claude release repo contents and release workflow only.