# Context Model (Scope Inference Fields)

In Scope, the conductor should infer a small set of structured context fields and record them explicitly.

Purpose:

1. Improve determinism of profile recommendations.
2. Reduce hidden assumptions (supports `inference-guardrails`).
3. Enable team async handoff and cross-tool portability.

These fields do not change the runtime execution mechanism. They are inputs that help recommend profiles/overlays and justify rule matrix choices.

## Fields

### `strictness`

How heavy governance should be for this run. This typically maps to the base profile choice.

Allowed values:

1. `lean`
2. `baseline`
3. `hardened`

### `change_type`

Allowed values:

1. `greenfield`
2. `bugfix`
3. `refactor`
4. `migration`
5. `breaking_change`
6. `unknown`

### `system_shape`

Allowed values:

1. `library`
2. `service`
3. `cli`
4. `frontend`
5. `monorepo`
6. `unknown`

### `delivery_surface`

Allowed values:

1. `api`
2. `data_model`
3. `ui`
4. `infra`
5. `runtime_config`
6. `unknown`

### `compliance_mode` (Optional)

Only record when applicable. Prefer overlays rather than a free-form dimension.

Allowed values:

1. `regulated`
2. `privacy_sensitive`
3. `none`
4. `unknown`

### Sensitivity flags (Optional)

1. `handles_sensitive_data`: `yes|no|unknown`
2. `prod_operated`: `yes|no|unknown`
3. `performance_critical`: `yes|no|unknown`

## Output Convention (Scope)

Record a context block in Scope outputs:

```text
context:
  strictness: <lean|baseline|hardened>
  change_type: <...>
  system_shape: <...>
  delivery_surface: <...>
  compliance_mode: <...> (optional)
  flags:
    handles_sensitive_data: <yes|no|unknown>
    prod_operated: <yes|no|unknown>
    performance_critical: <yes|no|unknown>
```

Also record:

1. evidence backing each field (file refs or request text)
2. confidence (high/medium/low)

