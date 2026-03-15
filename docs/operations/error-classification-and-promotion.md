# Error Classification And Promotion

Date: 2026-03-15
Status: Current

## Purpose

This document defines how to record, classify, and promote errors observed while developing, validating, packaging, or end-to-end testing this repository.

The goal is to avoid two common failures:

1. treating transient infrastructure problems as product conclusions
2. losing repeated evidence because every error remains trapped in transient chat history

## Storage Rule

Do not create a parallel `knowledge/ERRORS.md` tree for this repository.

Use canonical docs under `docs/operations/` for operational error knowledge.

If an error conclusion belongs to another category after review, promote it into that category instead of leaving the final truth only here.

## Error Classes

### 1. Deterministic Errors

These are reproducible, local, evidence-backed failures such as:

1. bad schema
2. wrong type
3. missing required field
4. broken path
5. invalid manifest shape
6. broken local link
7. prompt or skill contract mismatch

Rule:

1. If the evidence is local and reproducible, conclude immediately.
2. Fix or document the issue without waiting for repeated sightings.
3. Promote the conclusion into the canonical domain doc as soon as the real cause is understood.

### 2. Infrastructure Errors

These are environment or service failures such as:

1. network outage
2. timeout
3. rate limit
4. transient CLI/service failure
5. sandbox or permission disruption not caused by repo code

Rule:

1. Log the observation.
2. Do not treat a single event as a product conclusion.
3. Wait for repeated evidence or a clear causal chain before promoting it into canonical guidance.

## Minimum Error Record

When an error is important enough to retain, capture:

1. command, scenario, or harness step
2. environment and runtime
3. exact symptom
4. classification
5. current disposition

Recommended dispositions:

1. `one-off`
2. `watch`
3. `known issue`
4. `promoted`

## Promotion Rule

Error observations should graduate into the relevant canonical file once the conclusion is justified.

Typical destinations:

1. architecture issues:
   [../fdf-cross-agent-architecture.md](../fdf-cross-agent-architecture.md)
2. runtime semantics or path precedence:
   [../specification.md](../specification.md)
3. validation failures and release gates:
   [../validation-types-playbook.md](../validation-types-playbook.md)
4. spawned-agent failures and harness behavior:
   [../testing/README.md](../testing/README.md)
5. maintainer-operational expectations:
   [../../AGENTS.md](../../AGENTS.md)

The final truth should live in the best-fit canonical document, not only in an error log.

## Recording Policy

Record an error here when one or more of these is true:

1. the same failure has appeared multiple times
2. the failure can mislead future maintainers
3. the failure produced a real policy or workflow change
4. the conclusion is not yet stable enough for immediate promotion elsewhere

Do not record every transient command failure. This file is for reusable operational knowledge, not a raw terminal log.

## Examples

### Deterministic Example

Observation:

1. `plugin.json` uses `author` as a string when the manifest schema requires an object

Classification:

1. deterministic

Disposition:

1. promote immediately after fix confirmation

Destination:

1. validation or platform/distribution docs, depending on root cause

### Infrastructure Example

Observation:

1. a Claude or Codex session times out once during a long E2E run

Classification:

1. infrastructure

Disposition:

1. `watch`

Action:

1. keep the evidence
2. do not conclude product breakage until the pattern repeats or a stable cause is found
