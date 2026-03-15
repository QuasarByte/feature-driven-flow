# Codex-To-Codex Dialog Patterns

## 1. Purpose

This document explains how to structure tests where one Codex instance acts as the system under test and another agent or harness acts as the human operator.

In this repository, "Codex-to-Codex" does not mean two equal peers improvising indefinitely. It means:

1. one spawned Codex session performs the work
2. another controller, currently the harness or operator, evaluates its outputs and supplies follow-up answers

That distinction matters because a good E2E harness must stay auditable.

## 2. Roles

Use explicit roles in every scenario.

### Role A: Worker Agent

The spawned `codex` session that:

1. receives the task
2. asks questions if needed
3. performs implementation or analysis
4. exports FDF artifacts

### Role B: Operator Agent

The harness or external controller that:

1. launches the worker
2. watches transcript evidence
3. decides whether the worker asked the expected question
4. sends a real answer back into the resumed thread
5. evaluates final outputs

When writing articles or deeper research notes, describe this as "worker-agent / operator-agent" rather than "agent A / agent B". The names convey responsibility more clearly.

## 3. Core Dialog Shapes

### Pattern 1: Forced Clarification

Use when you need proof that the worker can pause and ask before implementation.

Shape:

1. prompt explicitly instructs the worker to ask one clarifying question
2. worker asks the question
3. operator answers
4. worker resumes and completes the task

Best for:

1. smoke tests for multi-turn behavior
2. verifying prompt and skill discovery
3. verifying thread resume and transcript capture

### Pattern 2: Conditional Branching

Use when the answer should change the implementation path.

Shape:

1. worker offers multiple options
2. operator chooses one
3. final outputs differ depending on the chosen branch

Best for:

1. proving resumed context is actually honored
2. testing profile selection or implementation variants

### Pattern 3: Approval Gate

Use when the worker should stop until approval is given.

Shape:

1. worker scopes the work
2. worker asks for approval
3. operator approves
4. worker implements only after approval

Best for:

1. policy-sensitive workflows
2. FDF scope-to-implement boundary testing

### Pattern 4: Recovery Or Repair

Use when the worker hits a known blocker and needs direction.

Shape:

1. worker begins implementation
2. worker reports a blocker
3. operator supplies a workaround or preference
4. worker continues

Best for:

1. environment-sensitive scenarios
2. path resolution and tool-discovery tests

## 4. Why Prompted Clarification Is Useful

For deterministic E2E work, a forced single clarification is valuable because it gives the harness a stable synchronization point.

Benefits:

1. easy to detect in transcript
2. easy to answer consistently
3. proves true multi-turn continuity
4. limits branching explosion

Avoid starting with open-ended conversational scenarios. They are harder to stabilize and harder to use as regression tests.

## 5. Recommended Answer Design

Operator answers should be:

1. short
2. explicit
3. immediately actionable
4. free of accidental new requirements

Good example:

```text
1
Use class name Main. Proceed with implementation, verification, and the requested FDF exports.
```

Bad example:

```text
Maybe Main, but also consider other names, and maybe add tests if it feels right.
```

The bad version injects ambiguity and makes failures hard to classify.

## 6. What The Operator Should Check Before Answering

Before sending the next-turn answer, the operator should inspect:

1. whether the worker actually asked a question
2. whether the question matches the scenario contract
3. whether the options are valid and understandable
4. whether the worker has already violated instructions

If the worker already drifted materially, the run should usually fail instead of being "rescued" by a clever answer.

## 7. Preventing Harness Self-Deception

A dialog harness can hide defects if it is too forgiving.

Do not let the operator:

1. answer a question the worker never asked
2. infer a thread id from external state when the transcript failed to produce one
3. silently rewrite the scenario goal mid-run
4. count fallback local behavior as an FDF success if the conductor was not actually used

The transcript must show the behavior you claim to have tested.

## 8. Escalating Toward Two-Agent Research

If you later build a true agent-to-agent experiment where both sides are LLM-driven, keep these layers separate:

1. harness protocol
2. agent prompts
3. scenario contract
4. scoring and assertions

Do not start by letting two unconstrained agents talk freely. That is useful for exploration, but weak for regression testing.

A practical maturity path is:

1. deterministic worker plus scripted operator
2. deterministic worker plus rule-driven operator
3. LLM worker plus LLM operator with strict answer schemas
4. richer open-dialog experiments after the evidence model is stable

## 9. FDF-Specific Guidance

When the worker session is expected to use FDF, the operator should require:

1. exported effective rule matrix
2. exported effective instructions
3. session report

Those exports let you inspect what the worker believed the active framework state was during the session.
