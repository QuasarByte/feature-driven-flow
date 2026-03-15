# Codex Dialog E2E Method

Date: 2026-03-15
Status: Current

## 1. Purpose

This document defines the method for running true end-to-end tests against Codex when the workflow requires dialog, clarification, and multi-turn progress instead of a single non-interactive prompt.

Use this method when you need to prove one or more of the following:

1. installed prompts are invokable by name
2. installed skills are discovered and actually used
3. FDF runtime assets resolve from the intended locations
4. Codex can ask a clarifying question and continue after a real answer
5. FDF artifacts are exported before session close
6. the generated code or files satisfy a runnable scenario

## 2. Definition Of "Real Dialog"

A real dialog E2E test means:

1. a real `codex` process is spawned
2. the test uses installed prompts and skills, not mocked prompt text pasted into another runner
3. the spawned session produces a real thread/session id
4. the first turn is allowed to ask a question
5. a later turn resumes the same thread and supplies an answer
6. the final assertions are made on real filesystem outputs and real transcript evidence

This repository treats `codex exec` followed by `codex exec resume <thread_id>` as a real dialog method.

Why this counts:

1. the model is not simulated
2. the session identity is preserved
3. the second answer changes the course of the same session
4. the transcript shows both the question and the answer path

This differs from a one-shot batch run, where all approvals and answers are pre-baked into the initial prompt.

## 3. Why The Harness Uses Resume Instead Of PTY First

There are two broad ways to drive a dialog-capable CLI agent:

1. PTY or expect-style control of a single long-lived process
2. session resume across multiple process invocations

The current Codex harness uses session resume first because it is simpler, more deterministic, and easier to preserve as test evidence.

Benefits:

1. each turn has a clean transcript file
2. process lifetime issues are simpler to debug
3. stdout capture is straightforward
4. no terminal emulation edge cases are required
5. the thread id is an explicit contract

Limitations:

1. it is not a byte-for-byte reproduction of a user typing into one uninterrupted terminal
2. it depends on Codex session resume support

For this repository, those tradeoffs are acceptable because the goal is behavioral proof, artifact capture, and harness portability, not terminal emulation fidelity.

## 4. Runtime Preconditions

Before running a dialog E2E test, ensure the following:

1. `codex` is installed and on `PATH`
2. the FDF Codex package has been installed into `~/.codex`
3. the target project is a disposable git repo
4. shared FDF runtime assets are available either:
   project-local as `./fdf`, or
   globally as `~/.codex/fdf`
5. the installed `feature-driven-flow` conductor skill is visible to Codex

Current hybrid asset resolution for Codex:

1. `./fdf` in the target project wins
2. `~/.codex/fdf` is the fallback

## 5. Current Reference Harness

The reference implementation is:

`tools/run-codex-dialog-e2e.ps1`

The harness performs the following sequence:

1. create a disposable project directory
2. initialize git in that directory
3. write the first-turn prompt to disk
4. run `codex exec` non-interactively with transcript capture
5. parse the JSONL event stream to extract the thread id
6. confirm the first turn asked a clarifying question
7. write the answer for the second turn
8. run `codex exec resume <thread_id>`
9. merge both transcripts into one session transcript
10. assert that required output artifacts exist
11. emit a JSON summary for machine or human consumption

## 6. Command Pattern

Turn 1:

```text
codex exec --dangerously-bypass-approvals-and-sandbox --json -o turn1-last-message.txt -C . - < turn1-prompt.txt > turn1-transcript.jsonl
```

Turn 2:

```text
codex exec resume <thread_id> --dangerously-bypass-approvals-and-sandbox --json -o turn2-last-message.txt - < turn2-prompt.txt > turn2-transcript.jsonl
```

Key observations:

1. prompt input is fed through stdin redirection
2. transcript output is captured in JSONL form from stdout
3. the human-readable last assistant message is captured separately with `-o`
4. the second process resumes the original thread instead of starting over

## 7. How To Run The Current Harness

From the repository root:

```powershell
pwsh -NoProfile -File tools/run-codex-dialog-e2e.ps1 -ProjectPath '.tmp/codex-dialog-e2e-java' -Force
```

What this does:

1. creates a fresh disposable project under `.tmp/`
2. runs the first Codex turn
3. extracts the thread id
4. resumes the same thread with the operator answer
5. writes transcripts and FDF exports into the project
6. prints a JSON summary at the end

Expected summary fields:

1. `project`
2. `thread_id`
3. `transcript`
4. `turn1_last_message`
5. `turn2_last_message`
6. `effective_rule_matrix`
7. `effective_instructions`
8. `session_report`
9. `final_message_excerpt`

## 8. Required Evidence

A dialog E2E run is not complete unless it preserves evidence.

Minimum evidence set:

1. first-turn transcript
2. second-turn transcript
3. combined session transcript
4. first-turn final message
5. second-turn final message
6. extracted thread id
7. generated scenario outputs
8. exported FDF artifacts

For FDF sessions, required framework exports are:

1. `.codex/feature-driven-flow/effective-rule-matrix.json`
2. `.codex/feature-driven-flow/effective-instructions-compact-portable.json`
3. `.codex/feature-driven-flow/session-report.md`

## 9. Scenario Example: Minimal Java Hello World

The current reference scenario asks Codex to:

1. create a minimal Java console app
2. ask exactly one clarifying question about the main class name
3. wait for the answer
4. implement the app
5. compile and run it if a local JDK is available
6. export FDF artifacts before finishing

The second turn answers with:

```text
1
Use class name Main. Proceed with implementation, verification, and the requested FDF exports.
```

This scenario is intentionally small. It isolates dialog behavior, artifact export, and basic implementation without the noise of a large app.

## 10. Assertions

The harness should assert only what is necessary to prove the scenario.

Current hard assertions:

1. first turn produced a question with answer options
2. thread id was extractable from transcript
3. `Main.java` exists
4. FDF export files exist

Scenario-specific optional assertions:

1. a JDK was found and compilation succeeded
2. program output matched `Hello, World!`
3. generated file contents match expected shape

Do not overfit assertions to incidental outputs such as README generation unless the scenario explicitly requires those files.

## 11. Failure Classes

Common failure classes for dialog E2E runs:

1. prompt resolution failure
   Example: `/prompts:fdf-start` is not recognized.
2. skill discovery failure
   Example: `feature-driven-flow` is installed on disk but absent from the session skill set.
3. asset resolution failure
   Example: FDF schemas or scripts are looked up in the wrong location.
4. placeholder parsing failure
   Example: an accidental `$NAME` token becomes a required prompt argument.
5. shell portability failure
   Example: an absolute path with spaces is not quoted.
6. tool availability failure
   Example: scenario verification assumes `rg`, `java`, or another tool on `PATH`.
7. question-shape drift
   Example: the model no longer asks the intended clarifying question.

Each failure should be diagnosed from transcript evidence first, not from guesswork.

## 12. Portability Rules

The harness and the scenarios should remain portable across Windows-first PowerShell execution and more general shell environments.

Rules:

1. quote paths in PowerShell
2. prefer native PowerShell discovery when external tools are missing
3. do not assume `rg` is installed
4. treat language toolchains such as Java as optional unless the scenario explicitly provisions them
5. save transcripts and artifacts in stable, predictable locations

## 13. Relationship To FDF Development Flow

Dialog E2E tests belong after source-level validation and distribution build verification.

Recommended sequence:

1. change source assets or harness code
2. run validation cycle
3. build distribution artifacts
4. install or sync the Codex package
5. run dialog E2E scenarios
6. inspect transcripts and exported FDF artifacts
7. only then treat the change as behaviorally verified

The goal is not just "the files built." The goal is "a real agent session behaved correctly."
