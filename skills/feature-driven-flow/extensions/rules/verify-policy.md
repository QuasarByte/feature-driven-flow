# Rule: verify-policy

## id
`verify-policy`

## title
Verify Policy

## applies_to_phases
`verify`

## intent
Close work with high-confidence findings and explicit user disposition.

## guidance
### verify
1. If no explicit diff/range is provided, default audit scope to current working diff.
2. Run parallel `fdf-change-auditor` passes where possible.
3. Consolidate findings into blocking and material groups.
4. Attach confidence per issue.
5. Report high-confidence findings by default (confidence >= 80).
6. Keep lower-confidence notes out unless user asks for them.
7. Ask user disposition: fix now, defer, or proceed.

## checks
### verify
1. Findings are severity-ranked.
2. Confidence is explicit.
3. Default report set is high-confidence unless user requested broader coverage.
4. Audit scope (explicit or default) is recorded.
5. User disposition is recorded.

## outputs
### verify
1. Consolidated findings report.
2. Confidence and remediation summary.
3. Smallest safe correction plan.
4. Residual uncertainty summary when no findings.
5. Disposition decision log.
