Refresh/rebuild effective instructions from current assets.

Task:
$ARGUMENTS

Requirements:
1. Start from the currently confirmed Effective Rule Matrix.
2. Re-resolve active rules/templates/references from current repository assets.
3. Rebuild compiled instructions for all 7 phases.
4. Export result as requested format:
   - directory bundle, or
   - compact file
5. If format/path is not provided, use `effective_instructions.export.*` defaults.
6. Report what changed versus previous compiled instructions when prior artifact exists.
