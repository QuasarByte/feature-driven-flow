# Claude Dialog E2E Method

Date: 2026-03-15
Status: Current

## 1. Purpose

This document defines the method for running true end-to-end dialog tests against Claude Code using the Feature-Driven Flow plugin from this repository.

Use this method when you need to prove one or more of the following:

1. the Claude slash command resolves from the plugin source or installed plugin
2. the `feature-driven-flow` conductor is actually invoked
3. FDF runtime assets resolve using the intended precedence
4. Claude can ask a clarifying question and continue after a real answer
5. FDF artifacts are exported before session close
6. the generated code or files satisfy a runnable scenario

## 2. Definition Of "Real Dialog"

A real Claude dialog E2E test means:

1. a real `claude` process is spawned
2. the test uses a real plugin, either from the installed environment or `--plugin-dir`
3. the first turn emits a real `session_id`
4. the first turn is allowed to ask a question
5. a later turn resumes the same session and supplies an answer
6. the final assertions are made on real filesystem outputs and real transcript evidence

This repository treats `claude -p` followed by `claude -p --resume <session_id>` as a real dialog method.

## 3. Runtime Preconditions

Before running a Claude dialog E2E test, ensure the following:

1. `claude` is installed and on `PATH`
2. the target project is a disposable git repo
3. the plugin is available either:
   by passing `--plugin-dir` with the source plugin path, or
   through the user-installed Claude plugin environment
4. shared FDF runtime assets are available in one of the supported locations

Current hybrid asset resolution for Claude:

1. `./fdf` in the target project wins
2. `~/.claude/fdf` is the fallback
3. bundled plugin `fdf` is the final fallback

## 4. Current Reference Harness

The reference implementation is:

`tools/run-claude-dialog-e2e.ps1`

The harness performs the following sequence:

1. create a disposable project directory
2. initialize git in that directory
3. write the first-turn prompt to disk
4. run `claude -p` with `--output-format stream-json`
5. parse the JSONL event stream to extract the `session_id`
6. confirm the first turn asked a clarifying question
7. write the answer for the second turn
8. run `claude -p --resume <session_id>`
9. merge both transcripts into one session transcript
10. assert that required output artifacts exist
11. emit a JSON summary for machine or human consumption

## 5. Command Pattern

Turn 1:

```text
claude -p --verbose --output-format stream-json --permission-mode bypassPermissions --plugin-dir <plugin-dir> --add-dir <project-dir>
```

Turn 2:

```text
claude -p --verbose --output-format stream-json --permission-mode bypassPermissions --plugin-dir <plugin-dir> --add-dir <project-dir> --resume <session_id>
```

Key observations:

1. prompt input is fed through stdin
2. transcript output is captured in JSONL form from stdout
3. the `session_id` comes from the `system/init` event
4. the second process resumes the original session instead of starting over

## 6. How To Run The Current Harness

From the repository root:

```powershell
pwsh -NoProfile -File tools/run-claude-dialog-e2e.ps1 -ProjectPath '.tmp/claude-dialog-e2e-java' -Force
```

What this does:

1. creates a fresh disposable project under `.tmp/`
2. runs the first Claude turn
3. extracts the `session_id`
4. resumes the same session with the operator answer
5. writes transcripts and FDF exports into the project
6. prints a JSON summary at the end

Expected summary fields:

1. `project`
2. `session_id`
3. `transcript`
4. `turn1_last_message`
5. `turn2_last_message`
6. `effective_rule_matrix`
7. `effective_instructions`
8. `session_report`
9. `final_message_excerpt`

## 7. Required Evidence

Minimum evidence set:

1. first-turn transcript
2. second-turn transcript
3. combined session transcript
4. first-turn final message
5. second-turn final message
6. extracted `session_id`
7. generated scenario outputs
8. exported FDF artifacts

For FDF Claude sessions, required framework exports are:

1. `.claude/feature-driven-flow/effective-rule-matrix.json`
2. `.claude/feature-driven-flow/effective-instructions-compact-portable.json`
3. `.claude/feature-driven-flow/session-report.md`

## 8. Scenario Example: Minimal Java Hello World

The current reference scenario asks Claude to:

1. create a minimal Java console app
2. ask exactly one clarifying question about the main class name
3. wait for the answer
4. implement the app
5. compile and run it if a local JDK is available
6. export FDF artifacts before finishing

The second turn answers with:

```text
confirmed
1
Use class name Main. Proceed with implementation, verification, and the requested FDF exports.
```

The leading `confirmed` is intentional. It keeps the scenario stable when the first turn remains at the FDF scope gate before the class-name clarification is consumed.

## 9. Failure Classes

Common failure classes for Claude dialog E2E runs:

1. slash-command resolution failure
2. plugin loading failure
3. conductor invocation failure
4. asset resolution failure
5. session resume failure
6. shell portability failure
7. tool availability failure

Each failure should be diagnosed from transcript evidence first, not from guesswork.
