# Scenario Authoring Guide

## 1. Purpose

This document explains how to author new dialog E2E scenarios that are useful as:

1. regression tests
2. harness demonstrations
3. article source material
4. FDF workflow proofs

## 2. Qualities Of A Good Scenario

A good scenario is:

1. small enough to run quickly
2. specific enough to assert clearly
3. rich enough to require at least one meaningful dialog turn
4. realistic enough to resemble actual use
5. stable enough to survive repeated runs

## 3. Start With Minimal Vertical Slices

Prefer a small but complete task over a broad one.

Good early examples:

1. Java hello-world with one clarifying question
2. add-two-numbers CLI with class-name or package-name choice
3. markdown report generator with output-file-name choice

Avoid large scenarios at first:

1. multi-module web apps
2. database-backed services
3. open-ended refactors

Those are useful later, but they create too many failure surfaces for a baseline regression suite.

## 4. Write The Scenario Contract Explicitly

Every scenario should define:

1. initial task
2. required clarifying question shape
3. allowed answer set
4. required artifacts
5. optional environment-dependent checks
6. pass criteria
7. fail criteria

Example contract skeleton:

```text
Task:
- Create a minimal Java console app.

Question contract:
- Ask exactly one clarifying question about the main class name.
- Offer two numbered options.

Answer contract:
- Operator answers with option 1 and a short imperative follow-up.

Required outputs:
- Main.java
- effective-rule-matrix.json
- effective-instructions-compact-portable.json
- session-report.md

Optional outputs:
- successful compile and run if JDK is available
```

## 5. Distinguish Hard And Soft Assertions

Hard assertions should cover the core contract only.

Examples:

1. question was asked
2. thread id exists
3. final code file exists
4. FDF exports exist

Soft assertions can provide extra confidence but should not make the suite brittle.

Examples:

1. exact wording of the explanatory prose
2. whether a README was generated
3. presence of extra helpful files not required by the task

## 6. Keep The Answer Stable

The operator response should be intentionally narrow.

Why:

1. it reduces accidental branching
2. it makes transcript comparisons easier
3. it keeps the scenario focused on the worker behavior under test

If you need coverage of multiple branches, create separate scenarios rather than one overloaded scenario.

## 7. Design For Environment Variability

Assume some machines will differ.

Plan for:

1. no `rg`
2. no Java or other language runtime on `PATH`
3. different shell defaults
4. different home-directory paths
5. runtime-specific export roots such as `.codex/feature-driven-flow` and `.claude/feature-driven-flow`

A strong scenario can still prove core behavior even when optional verification tools are absent.

## 8. Evidence First, Narration Second

When writing scenarios intended for future articles, capture the evidence in a form that can later support narrative writing.

Always save:

1. prompt files
2. answer files or answer text
3. transcripts
4. final outputs
5. FDF exports

Then your article can cite real artifacts instead of reconstructed memory.

## 9. Suggested Scenario Roadmap

As the suite grows, build coverage in layers:

1. single clarification, tiny code artifact
2. branch-sensitive implementation choice
3. approval gate before implementation
4. recovery after blocker
5. multi-file or multi-step implementation
6. cross-agent or multi-runtime comparisons

This progression gives you stable foundations before you attempt more ambitious dialog experiments.
