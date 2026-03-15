# Documentation Governance

Date: 2026-03-15
Status: Current

## Purpose

This repository treats `docs/` as the maintained knowledge base for architecture, runtime behavior, validation, distribution, and dialog E2E testing.

The goal is not to accumulate notes. The goal is to keep one coherent, current knowledge system that matches the source tree and real verified behavior.

## Canonical Structure

1. [INDEX.md](./INDEX.md) routes to categories.
2. Category documents own the details for their domain.
3. Platform references explain external platform mechanics.
4. Operations notes capture reusable failure patterns and error-promotion rules.
5. Generated artifacts and ad hoc transcripts are evidence, not primary knowledge docs.

## Knowledge Types

Organize docs using two top-level knowledge types:

1. Domain knowledge
   What things are.
   Examples: architecture, runtime semantics, artifact contracts, naming conventions, settings precedence.
2. Procedural knowledge
   How to do things.
   Examples: validation runs, deploy steps, release flow, test harness usage, review flows, error triage.

This distinction is a governance rule, not just a convenience.

## Boundaries

Use these boundaries strictly:

1. Architecture docs explain layout, packaging, and wrapper/shared boundaries.
2. Specification docs explain runtime semantics and artifact contracts.
3. Validation docs explain checks, failure triage, and release gates.
4. Testing docs explain spawned-agent methods, transcripts, and scenario design.
5. Operations docs explain how to classify and promote recurring failure patterns.
6. Distribution docs explain release-repo shape and publish workflow.

If a topic spans multiple categories, describe it once in the best-fit canonical file and link to it from the others.

When deciding where a document belongs, ask:

1. Is this primarily explaining the system itself?
   Put it in a domain-oriented document.
2. Is this primarily telling maintainers how to perform work?
   Put it in a procedural document.

## Merge Rule

Merge documents when:

1. they explain the same behavior with only minor wording differences
2. they require synchronized updates after every change
3. readers cannot tell which one is authoritative

Do not keep near-duplicate files only because they target different readers. Prefer one canonical explanation and short routing notes.

Also merge when a domain explanation and a procedure note are accidentally describing the same thing from two files without a clear boundary.

## Split Rule

Split a document when one or more of these conditions becomes true:

1. it covers multiple responsibilities that should evolve independently
2. readers need to search through large unrelated sections to find one answer
3. one subsection has become a reusable reference in its own right
4. updates to one topic create churn for unrelated topics in the same file

When splitting, leave behind a short router section that points to the new file.

## Prune Rule

Remove or rewrite content when:

1. the code no longer behaves as described
2. build or validation output disproves the document
3. a released artifact uses a different interface or path
4. the doc still describes an experimental layout that is no longer supported

Never preserve stale guidance just for historical context. Move historical narrative into an article or changelog, not the operational docs.

If a file mixes stable system facts with volatile workflow instructions, split it so the domain and procedural parts can change independently.

## Evidence Rule

Operational documentation changes should be grounded in at least one of:

1. source diff
2. validation result
3. distribution build result
4. transcript from a real spawned-agent E2E run
5. release-repo state

If no evidence exists, document the idea as a proposal, not as current behavior.

## Error Promotion Rule

Do not leave stable conclusions trapped in ad hoc error notes.

1. Deterministic, reproducible repo defects can be concluded immediately.
2. Infrastructure failures should usually remain observations until a pattern emerges.
3. Once the conclusion is justified, move it into the best-fit canonical document and leave operational notes as routing or supporting context.

## Agent Guidance Rule

When you notice repository behavior or maintainer expectations that should be reflected in [AGENTS.md](../AGENTS.md), propose or make the edit in the same change.

If Claude-specific discoverability also matters, keep [CLAUDE.md](../CLAUDE.md) as a thin pointer to [AGENTS.md](../AGENTS.md) unless there is truly Claude-only guidance.

Typical triggers:

1. new testing harnesses
2. changed artifact locations
3. changed install or runtime resolution rules
4. changed documentation governance rules
5. changed validation or release expectations

Do not wait for a separate request if the omission would leave maintainers with stale operator guidance.

## Review Checklist

Before closing a documentation change, check:

1. Is there a single canonical file for each changed topic?
2. Did I remove or rewrite stale statements instead of layering new text on top?
3. Do indexes route correctly to the new or changed docs?
4. Does `README.md` still point readers to the right starting places?
5. Should `AGENTS.md` also change?
