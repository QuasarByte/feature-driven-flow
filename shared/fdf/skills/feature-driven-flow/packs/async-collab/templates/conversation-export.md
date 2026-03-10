# Conversation Export (conversation-export.md)

Use this file only when needed to preserve chat context across tools (different computer, different LLM/agent) or after a long pause.

Preference order:

1. Persist decisions/risks/questions in the shared logs.
2. Persist phase outputs in `01-..` through `07-..`.
3. Use this file only to capture residual context not represented elsewhere.

## Snapshot Metadata

1. Run id:
2. Exported at:
3. Export reason:
4. Scope of export: `summary-only|summary+key-excerpts|full-transcript`

## High-Signal Summary (Required)

1. Problem statement:
2. Confirmed scope + non-goals:
3. Confirmed profiles + Effective Rule Matrix:
4. Key decisions (link to `decision-log.md`):
5. Current blocking items (link to `open-questions.md`):
6. Current risks (link to `risk-register.md`):
7. Next action:

## Key Q/A Excerpts (Optional)

Add only the minimal excerpts needed to preserve intent.

## Full Transcript (Optional, Last Resort)

If you must preserve the full transcript, paste it here.

