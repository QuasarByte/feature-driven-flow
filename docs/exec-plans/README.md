# Exec Plans

This directory defines the repository convention for execution plans used by agents and maintainers on larger tasks.

The goal is not to replace issue tracking or design docs. The goal is to give long-running implementation work a durable, inspectable plan with validation checkpoints.

## When To Use An Exec Plan

Create an exec plan when the task has one or more of these properties:

1. touches multiple files or subsystems
2. requires staged validation
3. will likely span more than one interactive turn or session
4. benefits from explicit milestones and acceptance criteria
5. is likely to be resumed by a different agent or maintainer later

## Minimum Structure

An exec plan should include:

1. Objective
2. Context
3. Constraints
4. Milestones
5. Validation
6. Risks or open questions

Use the template in [template.md](./template.md).

## Relationship To Other Docs

1. Use [../specification.md](../specification.md) for framework semantics.
2. Use [../validation-types-playbook.md](../validation-types-playbook.md) for validation families and release gates.
3. Use [../testing/README.md](../testing/README.md) when the plan includes dialog E2E work.
4. Use [../../AGENTS.md](../../AGENTS.md) for repo-wide maintainer expectations.

## Naming

Suggested file name pattern:

`YYYY-MM-DD-short-topic.md`

Example:

`2026-03-15-claude-dialog-e2e-hardening.md`
