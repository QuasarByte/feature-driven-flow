# Documentation Map

Use this directory as a set of focused documents, not one linear manual.
For the canonical category router, start with [INDEX.md](./INDEX.md).

## Read Order

1. `fdf-cross-agent-architecture.md`
   Read this first when you need repository layout, packaging model, and agent parity.
2. `../ARCHITECTURE.md`
   Read this for the short stable top-level architecture map before diving into detailed repo layout.
3. `specification.md`
   Read this for runtime behavior, artifact contracts, precedence, and customization rules.
4. `validation-types-playbook.md`
   Read this when changing assets, scripts, manifests, or release packaging.
5. `testing/README.md`
   Read this when working on dialog end-to-end harnesses, Codex or Claude interaction tests, or transcript/artifact evidence.
   The testing set includes separate method references for Codex and Claude.
6. `exec-plans/README.md`
   Read this when a task needs a durable execution-plan document with milestones and validation checkpoints.
7. `operations/README.md`
   Read this when turning repeated operational failures into stable repository guidance.
8. `distribution/claude-feature-driven-flow-repo-spec.md`
   Read this only when preparing or auditing the Claude marketplace repository.
9. `knowledge-governance.md`
   Read this when reorganizing docs, splitting categories, merging overlapping content, or pruning stale knowledge.

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
5. Dialog E2E testing
   Multi-turn spawned-agent verification, transcripts, artifact exports, and scenario design.
