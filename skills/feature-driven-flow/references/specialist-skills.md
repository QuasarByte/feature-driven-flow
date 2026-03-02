# Specialist Skills (Optional Lenses)

This framework can run entirely from the conductor + rules + templates.

The specialist skills are optional accelerators that act as "lenses" for a phase. They exist to:

1. Reduce prompt bloat by focusing the model on one job.
2. Improve consistency by reusing a small, dedicated instruction set.
3. Support parallel passes ("two perspectives") without inflating the conductor prompt.

They must not become a second policy layer.

## Governing Principle

Specialist skills must follow the active rule matrix for the run.

1. They must not introduce new requirements beyond what active rules/templates/references ask for.
2. If a specialist skill would normally do extra work, it should instead:
   - surface it as an optional suggestion, or
   - ask for user confirmation, or
   - record it as a risk/open question (depending on phase).
3. `AGENTS.md` constraints override everything.

## When To Use Which Skill

### `fdf-code-explorer` (Explore lens)

Use when:

1. The repo is non-trivial (multiple entry points, multiple layers, unclear seams).
2. You need a coherent runtime behavior map and must-read file set quickly.
3. You want parallel exploration passes with different perspectives.

Avoid when:

1. The change is small and localized and must-read files are obvious.

### `fdf-implementation-planner` (Architect lens)

Use when:

1. Architecture options require concrete file-level plans tied to repo realities.
2. You want a clean, explicit delivery sequence and interface delta map.
3. You need multiple options with explicit tradeoffs under time pressure.

Avoid when:

1. The "architecture" is effectively a contained delta with no meaningful option space.

### `fdf-change-auditor` (Verify lens)

Use when:

1. The diff is non-trivial and you want high-precision, low-noise findings.
2. You need confidence scoring and severity ranking to support a team disposition decision.
3. You want parallel audits to reduce blind spots.

Avoid when:

1. The change is extremely small and you can verify fully via tests and direct inspection.

## Interaction With Rules

1. Rules define required outputs/checks.
2. Specialist skills can help *produce* those outputs faster, but cannot redefine them.
3. If a specialist skill output conflicts with a rule:
   - the rule wins
   - record the conflict and ask the user to choose if needed

## Suggested Default Behavior

1. Default: do not invoke specialist skills.
2. Invoke when they materially reduce ambiguity/risk or when the user requests them explicitly.
3. If invoked, record it in the phase output under "Inputs" or "Applied Rules" notes.

