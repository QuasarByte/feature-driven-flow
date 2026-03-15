Run the Feature-Driven-Flow (FDF) workflow using the installed `feature-driven-flow` skill (`/prompts:fdf-start`).

Task:
$ARGUMENTS

Requirements:
Runtime asset resolution:
- Resolve shared FDF assets from the first available root in this order:
  - project-local `./fdf/` at the target project root
  - global Codex home `fdf/` directory (for example `%USERPROFILE%\.codex\fdf` on Windows or `~/.codex/fdf` on macOS/Linux)
- Never look for shared schemas or scripts under the installed Codex skill directory for `feature-driven-flow`.
- Use `fdf/schemas/*.json`, `fdf/scripts/*`, and `fdf/skills/feature-driven-flow/*` from the selected runtime root.
- Use `.codex/feature-driven-flow/` only for repo-local overrides and generated artifacts.

1. Execute all 7 phases in fixed order; do not skip or reorder phases, and honor phase gates/hard stops before advancing.
2. Keep core skeleton invariants intact (clarify gate, approval gate, verify-before-summary).
3. Infer execution context from request text, repository signals, and `AGENTS.md`.
4. In Scope, if the user asks to `load|import|use|read|reuse` matrix (file path or inline block), treat it as Effective Rule Matrix candidate input and parse/validate it first.
   If valid, present it as the candidate matrix with any required normalization notes or diffs.
   If invalid or not provided, propose profile selection (base + optional overlays) and compile a recommended matrix.
5. In Scope, if the user asks to load/import compiled/effective instructions (directory bundle or compact file, reference or portable), validate artifact format/content mode and present a disposition:
   - accept as candidate compiled instructions (with embedded matrix),
   - refresh from current assets,
   - discard and continue with current asset resolution.
   - if artifact includes `custom_instructions`, ask whether to accept as-is, edit/rephrase, or discard custom instructions.
6. Show the Effective Rule Matrix (compiled phase-by-phase active rules) for confirmation.
   In markdown files, render it as a native markdown table with one row per phase; in the rules cell, use backticked rule ids separated by commas.
   In terminal/chat output, do not render a table; render only a plain-text phase list.
7. Ask user to accept or adjust profiles and/or the Effective Rule Matrix before moving to Explore.
8. Apply rules per phase using extension precedence: core shared rules, enabled pack rules, then applicable repository-local rules (including local baseline when present).
9. Effective matrix export behavior:
   - If `matrix_export.auto_generate_on_scope_confirmed=true`, auto-save confirmed Effective Rule Matrix after Scope confirmation.
   - If user asks to `save|export` current/active/chosen/choice/effective/compiled matrix, export it on demand.
   - If user asks for ambiguous `state|compiled state`, ask a short clarification between Effective Rule Matrix export, Effective Instructions export, and `state.json` export.
   - Path resolution: explicit user path (if allowed) -> `matrix_export.default_file`.
   - Relative paths are repo-root relative; absolute paths allowed only when `matrix_export.allow_absolute_path=true`.
   - Respect `matrix_export.overwrite_existing`; if overwrite is disallowed, ask for confirmation/path change.
10. Effective instructions export behavior:
   - If `effective_instructions.export.auto_generate_on_scope_confirmed=true`, auto-save compiled instructions after Scope confirmation.
   - Support two output formats: directory bundle (canonical) and compact file.
   - Support content modes: `reference|portable|hybrid` from `effective_instructions.export.content_mode`.
   - `portable` and `hybrid` embed content and are suitable for cross-environment transfer.
   - Before portable/hybrid export, warn user about larger artifacts and potential sensitive source leakage.
   - If `effective_instructions.export.allow_custom_instructions=true`, ask user whether to include custom instructions before export.
   - If custom instructions are being included and `effective_instructions.export.require_custom_instructions_approval=true`, do not export until user explicitly approves final custom instruction text.
   - If `effective_instructions.export.require_all_custom_instruction_items_approved=true`, do not export unapproved custom items.
   - If unapproved custom items exist, notify user and ask for one decision: improve/rephrase and approve them, skip unapproved items and export only approved ones, or cancel export.
   - At minimum, present these numbered options (with one recommended): add new custom instruction(s), modify/rephrase existing candidate(s), continue without custom instructions.
   - If `effective_instructions.export.allow_custom_instruction_rephrase=true`, you may propose improved rephrasing of user-entered custom text; user approval is still required before export.
   - Store approved custom instructions in artifact field `custom_instructions`.
   - If user asks to convert directory bundle <-> compact, use `fdf/scripts/convert-effective-instructions.ps1`.
   - Respect path and overwrite policy from `effective_instructions.export.*`.
11. If rule guidance conflicts or is ambiguous, ask user to choose.
12. Treat `AGENTS.md` policy constraints as mandatory; if guidance conflicts, follow `AGENTS.md` and record the override.
13. Specialist skills (`fdf-code-explorer`, `fdf-implementation-planner`, `fdf-change-auditor`) are optional accelerators.
   Prefer following active rules/templates directly unless a specialist skill is explicitly requested by the user or helps materially reduce risk/ambiguity.
14. At every decision point, present numbered options, mark one as recommended, and ask the user to reply with a number or custom choice.
