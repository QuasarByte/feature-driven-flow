# FDF Knowledge Index

This `docs/` tree is the knowledge base for this repository. Do not create a parallel `knowledge/` tree unless the repository model changes.

Use this index as the routing entrypoint.

## Knowledge Types

This repository tracks two kinds of knowledge:

1. Domain knowledge
   What the system is: architecture, runtime semantics, artifact shapes, naming conventions, settings precedence, and cross-agent behavior.
2. Procedural knowledge
   How to work with the system: validation steps, test flows, exec plans, release operations, and error triage/promotion.

Keep these types distinct. Do not bury procedural instructions inside domain references when they need to evolve independently.

## Core Categories

1. Architecture
   [fdf-cross-agent-architecture.md](./fdf-cross-agent-architecture.md)
   Source layout, shared-vs-wrapper boundaries, packaging model, and agent parity.
2. Runtime Specification
   [specification.md](./specification.md)
   Workflow semantics, settings, artifacts, precedence, packs, and persistence behavior.
3. Validation And Release
   [validation-types-playbook.md](./validation-types-playbook.md)
   Validation families, failure triage, and release-gate expectations.
4. Dialog E2E Testing
   [README.md](./testing/README.md)
   Spawned-agent test methods, transcripts, artifact contracts, scenario design, and agent-native testing rationale.
5. Exec Plans
   [README.md](./exec-plans/README.md)
   Convention and template for long-running implementation plans.
6. Operations
   [README.md](./operations/README.md)
   Operational notes, error classification, and promotion rules.
7. Distribution
   [claude-feature-driven-flow-repo-spec.md](./distribution/claude-feature-driven-flow-repo-spec.md)
   Claude marketplace repo structure and release expectations.
8. Platform References
   [plugin-components-reference.md](./platform/claude-code/plugin-components-reference.md)
   [plugin-manifest-reference.md](./platform/claude-code/plugin-manifest-reference.md)
   Claude platform mechanics used as reference, not as the source of truth for repo behavior.
9. Documentation Governance
   [knowledge-governance.md](./knowledge-governance.md)
   How to split, merge, prune, and actualize repository knowledge.

## Maintenance Rules

1. Keep one canonical home for each topic.
2. Merge overlapping categories instead of letting parallel explanations drift.
3. Split documents once they become hard to navigate or begin mixing multiple responsibilities.
4. Remove or rewrite guidance that no longer matches the code, builds, validation, or E2E evidence.
5. When repository behavior changes, update the closest canonical document instead of appending a note elsewhere.

## First Read Order

1. [fdf-cross-agent-architecture.md](./fdf-cross-agent-architecture.md)
2. [specification.md](./specification.md)
3. [validation-types-playbook.md](./validation-types-playbook.md)
4. [README.md](./testing/README.md)

## Domain vs Procedural Map

Domain-heavy entrypoints:

1. [../ARCHITECTURE.md](../ARCHITECTURE.md)
2. [fdf-cross-agent-architecture.md](./fdf-cross-agent-architecture.md)
3. [specification.md](./specification.md)

Procedural-heavy entrypoints:

1. [validation-types-playbook.md](./validation-types-playbook.md)
2. [testing/README.md](./testing/README.md)
3. [exec-plans/README.md](./exec-plans/README.md)
4. [operations/README.md](./operations/README.md)
