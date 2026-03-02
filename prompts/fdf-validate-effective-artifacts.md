Validate effective artifacts (matrix, instructions bundle, instructions compact).

Task:
$ARGUMENTS

Requirements:
1. If `$ARGUMENTS` includes a specific path, validate that target artifact.
2. If no path is provided, validate default/template artifacts and known repo-local defaults.
3. Validate against schemas:
   - `schemas/fdf-effective-matrix.schema.json`
   - `schemas/fdf-effective-instructions-bundle.schema.json`
   - `schemas/fdf-effective-instructions-compact.schema.json`
   - `schemas/fdf-effective-instructions-bundle-portable.schema.json`
   - `schemas/fdf-effective-instructions-compact-portable.schema.json`
4. Apply path/policy expectations from settings where relevant.
5. Return a concise pass/fail report with concrete file paths and issues.
