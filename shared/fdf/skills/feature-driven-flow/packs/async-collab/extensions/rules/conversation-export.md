# Rule: conversation-export

## id
`conversation-export`

## title
Conversation Export (Optional Transcript Snapshot)

## tags
`persistence`, `portability`, `context`, `team`

## applies_to_phases
`scope`, `clarify`, `architect`, `verify`, `summarize`

## intent
Optionally export chat context into a versionable markdown file to support long pauses and cross-tool continuation when phase logs alone are insufficient.

## guidance
### scope
1. Default: do not export conversation unless `exports.conversation_export.enabled=true` or user requests it explicitly.
2. If enabled and persistence is enabled, create/update:
   - `<run_root_dir>/<run_id>/<exports.conversation_export.filename>` using `../../templates/conversation-export.md` (default: `conversation-export.md`)
3. Keep it summary-first; avoid dumping full transcripts unless strictly necessary.

### clarify
1. If enabled, update with:
   - key Q/A excerpts that materially affect decisions
   - any nuance not captured in `decision-log.md` and `open-questions.md`

### architect
1. If enabled, update with the option discussion nuance (only if not already captured in `04-architect.md` and `decision-log.md`).

### verify
1. If enabled, update with any disposition rationale nuance not captured in `06-verify.md` and `decision-log.md`.

### summarize
1. If enabled, add final summary snapshot and pointers to the authoritative phase/log files.

## checks
### scope
1. If enabled, export file path is recorded.

## outputs
### scope
1. Export file path (when enabled).
