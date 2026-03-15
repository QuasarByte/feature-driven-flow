# Agent-Native Testing Framework

Date: 2026-03-15
Status: Current design note

## 1. Thesis

If agent runtimes are becoming a real software substrate, then it makes sense to build a testing framework specifically for agent-native software.

In that model:

1. the software runs on top of AI agents
2. the software is often developed with AI agents
3. the software is validated through AI-agent-driven harnesses and evals

This repository already demonstrates the beginnings of that model through real spawned Codex and Claude dialog E2E harnesses.

## 2. Why Traditional Testing Is Not Enough

Classic software tests are still necessary, but they are not sufficient for agent-native systems.

Why:

1. behavior emerges across multiple turns, not one function call
2. tool usage and environment interaction are part of the runtime
3. the agent can modify state while reasoning
4. the final output can look correct even when the path was unsafe, wasteful, or inconsistent
5. non-determinism means one passing run does not fully describe system quality

For agent-native software, the thing under test is not just code. It is:

1. prompts and skills
2. tools and environment
3. agent decision paths
4. intermediate artifacts
5. final outputs
6. reliability across repeated trials

## 3. What This Repository Already Proves

This repository already uses agent-executed testing patterns that justify a dedicated framework:

1. real spawned Codex sessions
2. real spawned Claude Code sessions
3. multi-turn clarification and resume behavior
4. transcript capture
5. exported framework state
6. scenario-specific assertions on generated outputs

Current concrete examples:

1. [codex-dialog-e2e-method.md](./codex-dialog-e2e-method.md)
2. [claude-dialog-e2e-method.md](./claude-dialog-e2e-method.md)
3. [transcript-and-artifact-reference.md](./transcript-and-artifact-reference.md)
4. [run-codex-dialog-e2e.ps1](../../tools/run-codex-dialog-e2e.ps1)
5. [run-claude-dialog-e2e.ps1](../../tools/run-claude-dialog-e2e.ps1)

These are not generic unit tests. They are runtime harnesses for agent behavior.

## 4. Proposed Definition

An agent-native testing framework is a system that evaluates software whose behavior depends on AI agents by measuring:

1. final outputs
2. runtime trajectories
3. dialog behavior
4. tool and environment interaction
5. exported state and evidence
6. repeatability, cost, and failure rates across trials

In other words, it is closer to an eval harness plus runtime test framework than to a traditional unit-test library.

## 5. Core Test Layers

An agent-native testing framework should cover at least five layers.

### 5.1 Deterministic Artifact Layer

This layer checks:

1. schemas
2. manifests
3. generated files
4. path resolution
5. static contracts

In this repository, that corresponds to:

1. [validation-types-playbook.md](../validation-types-playbook.md)
2. `tools/run-validation-cycle.ps1`

### 5.2 Scenario Outcome Layer

This layer checks whether the agent completed the requested task.

Examples:

1. expected files exist
2. build succeeds
3. produced app behaves as required

### 5.3 Trajectory Layer

This layer checks how the agent reached the outcome.

Examples:

1. did it ask the required clarifying question
2. did it resume the same thread or session
3. did it use the expected command namespace
4. did it produce the required export artifacts
5. did it violate instructions while still producing a superficially correct result

### 5.4 Runtime Environment Layer

This layer checks the agent as an operating runtime.

Examples:

1. shell/tool availability
2. browser or UI behavior
3. logs, metrics, and traces
4. filesystem side effects

### 5.5 Reliability Layer

This layer checks repeated-run behavior.

Examples:

1. pass rate across repeated trials
2. failure clustering
3. latency
4. token usage or cost
5. stability under resume or recovery

## 6. Why "AI Agents Testing AI Agents" Makes Sense

Yes, it makes sense, with one important constraint.

It makes sense because:

1. the runtime is the agent
2. the development loop is agent-driven
3. the test harness can itself be agent-executed
4. many important behaviors only appear in real agent-to-environment interaction

But the test framework should not be fully self-legitimating.

It still needs:

1. human-defined acceptance criteria
2. canonical specs and invariants
3. explicit graders or assertions
4. release gates outside the model's own self-explanation

So the more accurate formulation is:

1. AI agents can run tests on AI-agent-based software
2. AI agents can even help evaluate other AI agents
3. but the quality bar must still be defined by human-owned policy, specs, and measurable checks

## 7. Closed-Loop Development

The idea of a closed loop is useful if stated carefully.

Closed loop in this context means:

1. software is implemented through agent-driven workflows
2. software executes through agent runtimes
3. software is validated through agent-executed harnesses and evals
4. repository knowledge and feedback loops are encoded back into the repo

This repository already has parts of that loop:

1. agent-facing maintainer contract in [AGENTS.md](../../AGENTS.md)
2. top-level architecture map in [ARCHITECTURE.md](../../ARCHITECTURE.md)
3. procedural testing docs in this `docs/testing/` set
4. real multi-turn Codex and Claude harnesses
5. validation and release gates

The loop is closed operationally, but not philosophically. Humans still define the rules of the system.

That is a strength, not a weakness.

## 8. Suggested Architecture For A Real Framework

If this repository evolves toward a fuller agent-native testing framework, the framework should contain:

1. scenario definitions
   Task, expected dialog shape, required artifacts, optional environment checks.
2. runtime adapters
   Codex adapter, Claude adapter, and future agent-runtime adapters.
3. transcript collectors
   Per-turn JSONL capture, session/thread ids, last-message extraction.
4. graders
   Deterministic assertions first, LLM or heuristic judges only where needed.
5. trial runner
   Repeated execution with metrics such as pass@1 and consistency across runs.
6. report layer
   Artifacts, transcripts, scores, failure clusters, and promotion-ready findings.

## 9. Test Taxonomy For This Repository

This repository is already close to a practical taxonomy.

Recommended categories:

1. framework validation
   Manifests, schemas, links, path integrity, naming rules.
2. runtime smoke tests
   Prompt or command resolution, skill visibility, plugin loading.
3. dialog E2E tests
   Clarification, approval, resume, exports, final outputs.
4. environment-aware tests
   JDK present or absent, shell-tool fallbacks, browser or observability checks when added.
5. repeated-trial evals
   Same scenario repeated to measure success rates and variance.

## 10. Design Principles

If you build this further, use these principles:

1. transcripts are first-class test artifacts
2. trajectory matters, not only final output
3. deterministic assertions should dominate where possible
4. repeated trials matter because single-run success can mislead
5. human-owned specifications remain the source of truth
6. promotion of findings into repo docs should be part of the framework lifecycle

## 11. Why It Matters

If agent-native software is a real software category, then it needs:

1. architecture patterns
2. maintainer contracts
3. operational governance
4. eval and testing frameworks designed for agent runtimes

This repository already contains the first meaningful pieces of such a framework.

## 12. Source Context

This design note is aligned with:

1. OpenAI, "Harness engineering: leveraging Codex in an agent-first world"
   [openai.com/index/harness-engineering](https://openai.com/index/harness-engineering)
2. Anthropic, "Demystifying evals for AI agents"
   [anthropic.com/engineering/demystifying-evals-for-ai-agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)
3. The local reading set in [ai_engineering_reading_dataset](../ai_engineering_reading_dataset/README.md)
