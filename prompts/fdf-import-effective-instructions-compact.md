Import compiled/effective instructions from compact single-file format.

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as optional compact JSON file path.
2. If path is missing, try default from settings:
   - `effective_instructions.import.default_compact_file`
3. Validate candidate against:
   - `schemas/fdf-effective-instructions-compact.schema.json`
4. Validate embedded matrix and phase instruction coverage consistency.
5. If `custom_instructions` exists and `effective_instructions.import.allow_custom_instructions=true`, ask user to:
   - accept imported custom instructions as-is,
   - modify/rephrase before use,
   - discard imported custom instructions.
6. If `effective_instructions.import.require_custom_instructions_confirmation=true`, do not apply imported custom instructions until user confirms.
7. Ask user to accept imported compiled instructions, refresh from current assets, or discard.
8. Record source, validation result, custom instruction disposition, and final disposition in Scope outputs when applicable.
