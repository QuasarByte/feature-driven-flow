# AGENTS.md

This file is the canonical cross-agent maintainer guidance for the `feature-driven-flow` source repository.

It is intended for Codex, Claude, and other repository-aware agent tooling.

## First Read

1. Start with [docs/INDEX.md](./docs/INDEX.md).
2. Use [ARCHITECTURE.md](./ARCHITECTURE.md) for the stable high-level repository map.
3. Use [docs/specification.md](./docs/specification.md) for runtime semantics.
4. Use [docs/validation-types-playbook.md](./docs/validation-types-playbook.md) for validation and release checks.
5. Use [docs/testing/README.md](./docs/testing/README.md) for spawned-agent dialog E2E methods.
6. Use [docs/operations/README.md](./docs/operations/README.md) for reusable operational failure patterns and error-promotion rules.

## Documentation Hygiene

1. Treat `docs/` as the canonical knowledge base. Do not create a parallel `knowledge/` tree.
2. Keep one authoritative file per topic and link to it from indexes or adjacent docs.
3. Distinguish domain knowledge from procedural knowledge.
4. Put stable system facts in domain docs such as architecture and specification.
5. Put workflow instructions in procedural docs such as validation, testing, exec-plans, and operations.
6. Split documents that become too broad or too long to navigate efficiently.
7. Merge overlapping documents when they describe the same behavior.
8. Remove or rewrite stale guidance promptly when code, validation, or E2E evidence changes.
9. When behavior changes, update the closest canonical doc in the same change.

Detailed policy lives in [docs/knowledge-governance.md](./docs/knowledge-governance.md).

## When To Update This File

Update `AGENTS.md` when maintainers need new operator guidance for:

1. installation or runtime resolution changes
2. validation or release workflow changes
3. dialog E2E harness changes
4. documentation governance changes
5. repository architecture entrypoint changes
6. repo-wide conventions that affect cross-agent maintenance
7. stable error-classification or error-promotion rules

Do not wait for a separate request if the omission would leave this file stale.
