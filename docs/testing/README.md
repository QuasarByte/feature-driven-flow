# Dialog E2E Testing

Use this document set when you need to design, run, extend, or explain end-to-end tests that involve real AI-agent dialog instead of one-shot prompt execution.

The primary scope is Codex and Claude Code dialog testing. This repository now includes working multi-turn harnesses for both runtimes, and the same method definitions establish the baseline for future cross-agent dialog harnesses.

## Read Order

1. `codex-dialog-e2e-method.md`
   Read this first for the actual test method, execution model, and why resumed sessions count as real dialog for Codex.
2. `claude-dialog-e2e-method.md`
   Read this for the corresponding Claude Code method, plugin-loading model, and session-resume mechanics.
3. `transcript-and-artifact-reference.md`
   Read this when you need the exact evidence model: transcripts, thread ids, exported FDF artifacts, and pass/fail assertions.
4. `agent-native-testing-framework.md`
   Read this when you want the higher-level case for agent-native testing and the proposed test taxonomy beyond the current harness scripts.
5. `scenario-authoring-guide.md`
   Read this when you need to create new scenarios, stabilization rules, or article-grade examples.
6. `codex-to-codex-dialog-patterns.md`
   Read this when designing scenarios where one agent asks questions and the harness answers like a human operator.

## What This Set Covers

1. What qualifies as a real dialog E2E test.
2. How to run spawned Codex and Claude sessions as a user would.
3. How to answer clarifying questions across multiple turns.
4. How to capture transcripts and exported FDF context.
5. How to assert outcomes without hiding model behavior.
6. How to keep scenarios portable across shells, machines, and installed tool differences.
7. Why a broader agent-native testing framework makes sense for this repository category.

## What This Set Does Not Cover

1. Claude plugin packaging details.
   Use `../distribution/claude-feature-driven-flow-repo-spec.md`.
2. Core FDF runtime semantics and precedence.
   Use `../specification.md`.
3. General repository architecture and shared-vs-wrapper layout.
   Use `../fdf-cross-agent-architecture.md`.
4. Baseline validation checks for manifests, schemas, and release assets.
   Use `../validation-types-playbook.md`.

## Current Harness Entry Points

The current working Codex dialog harness is:

`tools/run-codex-dialog-e2e.ps1`

The current working Claude dialog harness is:

`tools/run-claude-dialog-e2e.ps1`

These scripts are the concrete implementation references for the method defined in this document set.
