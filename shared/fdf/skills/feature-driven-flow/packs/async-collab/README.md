# Pack: async-collab

Async collaboration + persistence for Feature-Driven-Flow.

This pack adds:

1. Run directory persistence (phase files + logs)
2. Async question/decision packets (TUI markdown)
3. Cross-agent portability exports (RUNBOOK.md, state.json, optional conversation export)

How to enable (recommended via repo settings):

1. Add `async-collab` to `packs.enabled` in `.codex/feature-driven-flow/settings.json`.
2. Optionally select the `async-collab-overlay` profile in your rule matrix/profile selection.
