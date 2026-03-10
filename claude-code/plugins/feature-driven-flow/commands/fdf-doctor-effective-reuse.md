---
description: FDF — run diagnostics for effective artifact reuse workflows
allowed-tools: Read, Glob
---

Task: $ARGUMENTS

Requirements:
1. Check existence/validity of:
   - matrix artifact
   - instructions bundle
   - instructions compact file
2. Check settings/policy blockers:
   - import/export enabled flags
   - absolute-path policy
   - overwrite policy
3. Check schema compatibility and required file layout using schemas in `fdf/schemas/`.
4. Return prioritized issues with concrete remediation steps.
