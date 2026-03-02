Import an Effective Rule Matrix artifact for the current run.

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as one of:
   - file path to matrix JSON
   - inline JSON block
2. If no path/block is provided, try default path from settings:
   - `matrix_import.default_file`
3. Validate candidate against:
   - `schemas/fdf-effective-matrix.schema.json`
4. If validation passes:
   - present normalized matrix as plain-text phase list in terminal/chat
   - ask user to accept, adjust, or discard
5. If validation fails:
   - show concrete validation issues
   - ask user to provide fixes/path or fall back to profile-based compilation
6. Record source (`file|inline|default`), validation result, and user decision in Scope outputs when applicable.
