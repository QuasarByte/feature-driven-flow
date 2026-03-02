# Profile Recommendations (Deterministic Mapping)

Use this as a deterministic, documented mapping from inferred execution context to recommended profile selection.

Goal: reduce repeated decisions while keeping provenance explicit.

## Inputs (From Scope Inference)

1. `system_shape`: `library|service|cli|frontend|monorepo|unknown`
2. `change_type`: `greenfield|bugfix|refactor|migration|breaking_change|unknown`
3. `delivery_surface`: `api|data_model|ui|infra|runtime_config|unknown`
4. Sensitivity flags:
   - `handles_sensitive_data`: `yes|no|unknown`
   - `prod_operated`: `yes|no|unknown`
   - `performance_critical`: `yes|no|unknown`

## Recommended Base + Overlays

Choose exactly one base profile:

1. Base: `lean-baseline`
   - Use when: local experiments, demos, low-risk codebases, or fast iteration where governance must stay minimal.
2. Base: `baseline`
   - Use when: default choice for non-trivial work in most repos.
3. Base: `hardened`
   - Use when: production service changes, migrations, breaking changes, or elevated risk surface.

Add overlays when the triggering condition holds:

1. Overlay: `security-overlay`
   - Trigger: `handles_sensitive_data=yes` or any new authn/authz boundary or external data ingestion.
2. Overlay: `operations-overlay`
   - Trigger: `prod_operated=yes` or changes in deploy/rollout/rollback behavior.
3. Overlay: `performance-overlay`
   - Trigger: `performance_critical=yes` or changes on hot paths / high-frequency endpoints.
4. Overlay: `release-overlay`
   - Trigger: `change_type in (migration, breaking_change)` or any change that affects release/rollout strategy.

## Notes

1. This mapping recommends profiles. The compiled rule matrix must still be explicitly confirmed by the user.
2. If `AGENTS.md` mandates specific rules, those constraints take precedence over recommendations.

