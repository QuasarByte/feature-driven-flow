Compare two Effective Rule Matrix artifacts and show differences.

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as two matrix inputs (`old` and `new`) by path or inline blocks.
2. Validate both inputs against `fdf/schemas/fdf-effective-matrix.schema.json`.
3. Show phase-by-phase delta:
   - added rules
   - removed rules
   - unchanged rules
4. If one input is missing/invalid, explain the specific issue and stop.
5. Render diff as plain-text sections in terminal/chat (no markdown table).
