# Transcript And Artifact Reference

## 1. Purpose

This document defines the evidence model for dialog E2E tests. If a run cannot produce this evidence, it is incomplete as a regression proof.

## 2. Transcript Layers

The current harness preserves three transcript layers.

### 2.1 Turn Transcript

One JSONL file per process invocation.

Current names:

1. `turn1-transcript.jsonl`
2. `turn2-transcript.jsonl`

Purpose:

1. preserve raw event order for each invocation
2. make turn-local debugging easier
3. simplify failures where the first turn never reaches a valid resume point

### 2.2 Combined Session Transcript

Current name:

1. `session-transcript.jsonl`

Purpose:

1. preserve one linear evidence file for the full scenario
2. simplify article examples and debugging
3. provide a single artifact for archival or later replay analysis

### 2.3 Last-Message Files

Current names:

1. `turn1-last-message.txt`
2. `turn2-last-message.txt`

Purpose:

1. capture the final assistant-visible answer for each turn
2. support easy assertion on the question or final result without parsing all events

## 3. Thread Id Contract

The worker must emit a thread or session id in the first-turn event stream.

Current extraction rule in the harness:

1. parse the JSONL stream
2. find the first `thread.started` event
3. read `thread_id`

This id is a hard dependency for resumed dialog testing. If it is missing, the run must fail.

## 4. FDF Artifact Contract

When the session is expected to run under FDF, the worker must export runtime-specific artifacts.

For Codex:

1. `.codex/feature-driven-flow/effective-rule-matrix.json`
2. `.codex/feature-driven-flow/effective-instructions-compact-portable.json`
3. `.codex/feature-driven-flow/session-report.md`

For Claude:

1. `.claude/feature-driven-flow/effective-rule-matrix.json`
2. `.claude/feature-driven-flow/effective-instructions-compact-portable.json`
3. `.claude/feature-driven-flow/session-report.md`

These artifacts answer different questions:

1. effective rule matrix
   Which rules and profiles were active.
2. effective instructions compact portable
   What compiled instruction payload the worker exported in transportable form.
3. session report
   What happened in a concise human-readable summary.

## 5. Scenario Output Contract

Scenario outputs are separate from framework outputs.

For the Java hello-world scenario, the primary output is:

1. `Main.java`

Secondary outputs such as README files should be asserted only when the scenario explicitly requires them.

## 6. Suggested Directory Layout For Runs

```text
<project-root>/
|-- turn1-prompt.txt
|-- turn2-prompt.txt
|-- turn1-transcript.jsonl
|-- turn2-transcript.jsonl
|-- session-transcript.jsonl
|-- turn1-last-message.txt
|-- turn2-last-message.txt
|-- Main.java
`-- .codex/ or .claude/
    `-- feature-driven-flow/
        |-- effective-rule-matrix.json
        |-- effective-instructions-compact-portable.json
        `-- session-report.md
```

This layout is useful because all run evidence stays close to the generated project while framework exports remain namespaced under the runtime-specific `.codex/feature-driven-flow/` or `.claude/feature-driven-flow/` directory.

## 7. How To Read A Failed Run

Recommended order:

1. `turn1-last-message.txt`
2. `turn1-transcript.jsonl`
3. `turn2-last-message.txt`, if turn 2 exists
4. `session-transcript.jsonl`
5. exported FDF artifacts

Typical diagnostic questions:

1. Was the prompt recognized?
2. Was the conductor skill available?
3. Did the worker ask the expected question?
4. Did the operator answer the same thread?
5. Did the final outputs match the chosen branch?
6. Did FDF exports reflect the intended framework state?

## 8. What To Preserve For Research Or Articles

For article-quality material, preserve:

1. the prompt text
2. the operator answer text
3. the combined transcript
4. the final generated code
5. the exported FDF artifacts
6. the exact build or execution command used for verification

That bundle is enough to reconstruct the narrative of the run without hand-waving.

## 9. Redaction Guidance

Before publishing transcripts externally:

1. remove absolute local machine paths if needed
2. remove usernames if they are sensitive
3. keep thread structure and event order intact
4. do not edit the transcript to hide defects

If you publish an excerpt, label it as an excerpt and retain the original full transcript in the harness artifacts.
