---
description: FDF — validate effective artifacts (matrix, instructions bundle, instructions compact)
allowed-tools: Read, Glob
---

Task: $ARGUMENTS

Requirements:
1. If `$ARGUMENTS` includes a specific path, validate that target artifact.
2. If no path is provided, validate default/template artifacts and known repo-local defaults.
3. Validate against schemas:
   - `fdf/schemas/fdf-effective-matrix.schema.json`
   - `fdf/schemas/fdf-effective-instructions-bundle.schema.json`
   - `fdf/schemas/fdf-effective-instructions-compact.schema.json`
   - `fdf/schemas/fdf-effective-instructions-bundle-portable.schema.json`
   - `fdf/schemas/fdf-effective-instructions-compact-portable.schema.json`
4. Apply path/policy expectations from settings where relevant.
5. Return a concise pass/fail report with concrete file paths and issues.
