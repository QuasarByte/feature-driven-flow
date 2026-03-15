# Phases (What Each Phase Is For)

Feature-Driven-Flow runs 7 phases in fixed order:

`Scope -> Explore -> Clarify -> Architect -> Implement -> Verify -> Summarize`

This document explains the purpose of each phase in plain language (for users) and as an execution contract (for the LLM).

## 1. Scope

Purpose:

1. Establish the intended outcome, scope boundaries, and measurable success criteria.
2. Infer and record structured context fields (see `context-model.md`).
3. If provided by the user, validate imported Effective Rule Matrix candidate (file path or inline block).
4. If provided by the user, validate imported Effective Instructions candidate (directory bundle or compact file) and content mode (`reference|portable|hybrid`).
5. Select governing profiles/rules and compile matrix when no valid import is provided.
6. Confirm the Effective Rule Matrix with the user before any repository changes.
7. Export the confirmed matrix when auto-generation is enabled or when user requests save/export.
8. Export compiled instructions (bundle or compact) when auto-generation is enabled or when user requests save/export.
9. If using portable/hybrid content mode, warn user about artifact size and possible sensitive source sharing risk.

Key outputs:

1. Scope summary + success criteria.
2. Context-model fields with evidence and confidence.
3. Matrix candidate source + validation result (when import is used).
4. Compiled instructions candidate source + validation result (when import is used).
5. Selected profiles (if any) + confirmed Effective Rule Matrix.
6. Exported matrix path(s) when auto-generation or on-demand export occurs.
7. Exported compiled instructions path(s), format(s), and content mode(s) when auto-generation or on-demand export occurs.

Hard stops:

1. Do not proceed to Explore until the rule matrix is confirmed.

## 2. Explore

Purpose:

1. Map the current behavior and change surface with concrete file references.
2. Identify integration boundaries, data contracts, side effects, and must-read files.
3. Reduce the risk of designing against an incorrect mental model.

Key outputs:

1. Trigger surfaces + runtime path map.
2. Dependency/boundary map.
3. Must-read file list for downstream phases.

Hard stops:

1. Avoid proposing implementation changes unless the user explicitly asks.

## 3. Clarify

Purpose:

1. Resolve decision-critical ambiguity (edge behavior, failure semantics, contracts).
2. Convert "vibes" into explicit decisions and acceptance criteria.
3. Stay blocked until critical ambiguity is resolved or explicitly accepted as a risk.

Key outputs:

1. Prioritized questions.
2. Decisions/assumptions recorded in `decision_log` and `open_questions`.

Hard stops:

1. Do not proceed to Architect while decision-critical ambiguity remains.

## 4. Architect

Purpose:

1. Produce explicit options with tradeoffs.
2. Choose a delivery path that matches repo constraints and the selected rules.
3. Create a file-by-file plan and ordered delivery sequence.

Key outputs:

1. At least 3 options + recommendation (when required by rules).
2. Interface deltas and file-level plan.
3. User-selected option recorded.

Hard stops:

1. Do not proceed without an explicit user choice when rules require it.

## 5. Implement

Purpose:

1. Apply the chosen architecture/design safely and within confirmed scope.
2. Keep change tracking and traceability updated (files/checks/decisions).

Key outputs:

1. Changed files summary.
2. Scope adherence notes.
3. Implementation risks/gaps tracked.

Hard stops:

1. Do not start implementation without explicit user approval.

## 6. Verify

Purpose:

1. Validate correctness and quality dimensions required by active rules.
2. Produce a severity-ranked findings list with confidence.
3. Obtain explicit user disposition (fix now / defer / proceed).

Key outputs:

1. Findings report.
2. Remediation plan (minimal safe fix set).
3. Disposition decision recorded.

Hard stops:

1. Do not close the workflow without Verify.

## 7. Summarize

Purpose:

1. Produce a closure package for handoff: what changed, why, evidence, next actions.
2. Capture a small retro and execution metrics when applicable.

Key outputs:

1. Final summary package.
2. Follow-up actions assigned.

Hard stops:

1. Verify must be completed before Summarize.

## Notes

1. Phase checklists are derived from active rules (`checks`) plus core invariants.
2. If persistence/async collaboration is enabled (via packs/settings), phase outputs should be mirrored into the run directory artifacts.
