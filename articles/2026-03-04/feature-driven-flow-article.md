
# Feature-Driven-Flow: Governance-Driven AI Software Engineering
### A New Architecture for Feature-Driven and Specification-Driven Development in the AI Era

AI coding assistants have rapidly changed how software is written. In many teams today, development already involves **LLM agents producing architecture suggestions, implementation drafts, and test suites**. However, most AI-assisted workflows still operate through **interactive chat sessions**, which lack structure, reproducibility, and governance.

This has led to the emergence of **AI development frameworks**—systems that define how AI agents should participate in software engineering processes.

Among these frameworks are:

- **Specification-driven frameworks** such as Spec-Kit  
- **Agent-orchestration frameworks** such as OpenAgentsControl  
- **Skill-based frameworks** such as Superpowers  
- **Context-engineering frameworks** such as Get-Shit-Done (GSD)

Within this ecosystem, **Feature-Driven-Flow (FDF)** introduces a different approach. Instead of focusing primarily on prompts, agents, or skills, FDF focuses on **governance and workflow determinism**.

Its central idea is simple but powerful:

> AI development workflows should be governed by explicit policy artifacts rather than ad-hoc prompts.

---

# The Problem with Current AI Development Workflows

Most AI coding workflows today resemble this pattern:

```
prompt
 → AI generates code
 → user adjusts prompt
 → AI refines result
```

While effective for small tasks, this model fails when projects become more complex. Several problems arise:

- **Context loss** across sessions
- **Lack of reproducibility**
- **Unstructured decision making**
- **Difficulty collaborating asynchronously**
- **No formal governance of the development process**

As projects grow, development requires more than prompt refinement. It requires **structured workflows**.

---

# The Core Idea of Feature-Driven-Flow

Feature-Driven-Flow introduces a **governed workflow architecture** for AI-assisted development.

At its core is a **fixed seven-phase workflow**:

```
Scope → Explore → Clarify → Architect → Implement → Verify → Summarize
```

The framework enforces strict invariants:

- phases cannot be skipped or reordered
- implementation requires explicit approval
- ambiguity must be resolved before implementation
- verification must occur before completion

This structure transforms AI development from an interactive chat process into a **controlled engineering workflow**.

---

# Rule-Driven Workflow Governance

The most important architectural element of FDF is the **rule system**.

Rules are defined as **Markdown artifacts** that specify:

- which workflow phases they apply to
- guidance for execution
- validation checks
- required outputs

These rules are then compiled into a **Rule Matrix**, which determines how a specific workflow run should behave.

Conceptually:

```
rules + profiles
      ↓
compiled rule matrix
      ↓
workflow execution
```

This approach separates:

- **policy definition** (rules)
- **workflow configuration** (matrix)
- **workflow execution** (phases).

---

# The Effective Rule Matrix

The **Effective Rule Matrix** is the canonical execution artifact in FDF.

It defines:

```
phase → [rule_id...]
```

The matrix is:

- proposed or imported during the Scope phase
- validated by schema
- explicitly confirmed by the user
- used to generate phase checklists and outputs

This makes the workflow **deterministic and auditable**.

Unlike many AI frameworks where policies are embedded inside prompts, FDF treats workflow rules as **first-class artifacts**.

---

# Profiles and Policy Bundles

Rules can be grouped into **profiles**, which represent reusable policy sets.

Typical profiles include:

- baseline development
- hardened production workflows
- security overlays
- testing overlays

Profiles act as **inputs** to workflow configuration. The actual execution logic is always derived from the compiled matrix.

---

# Micro-Core Architecture

FDF uses a **micro-core architecture**.

The core contains only the minimal elements needed for workflow execution:

- workflow phases
- governance rules
- essential templates

All other functionality is modular.

This prevents the framework from becoming monolithic and allows workflows to remain **stable and predictable**.

---

# Packs: Extending the Workflow

Additional capabilities are provided through **packs**.

Packs are modular repositories containing:

- rules
- profiles
- templates
- reference materials

Examples include:

| Pack | Purpose |
|-----|-----|
| async-collab | asynchronous collaboration |
| quality | engineering standards |
| hardening | security and operational policies |
| presets | reusable profiles |
| observability-lite | workflow diagnostics |

Packs extend the system without modifying the core workflow.

---

# Asynchronous Development Workflows

One of the most important features of FDF is **asynchronous collaboration**.

Most AI coding tools assume continuous interaction between a user and a model. However, real development often involves:

- multiple developers
- multiple AI agents
- work spanning hours or days

FDF supports asynchronous workflows through **persistent run artifacts**.

When enabled (typically via the async-collab pack), each workflow execution generates a directory containing:

- phase reports
- decision logs
- risk registers
- open questions
- traceability records

Example structure:

```
run_directory/
 ├─ 01-scope.md
 ├─ 02-explore.md
 ├─ decision-log.md
 ├─ risk-register.md
 └─ traceability.md
```

These artifacts allow another agent or developer to **resume the workflow later**.

The development context is therefore stored in **version-controlled artifacts instead of chat sessions**.

---

# Portable Workflow Instructions

FDF also introduces **Effective Instructions artifacts**.

These are compiled workflow instructions generated from the rule matrix.

They can be exported in two formats:

- directory bundles
- compact JSON files

These artifacts allow workflows to be reused across environments and agents.

Supported portability modes include:

- **reference mode** (lightweight, local references)
- **portable mode** (embedded content)
- **hybrid mode** (both)

This feature enables workflows to be transferred between different AI systems without losing context.

---

# Comparison with Other AI Development Frameworks

To understand the niche of FDF, it helps to compare it with other frameworks.

| Framework | Core Idea | Main Focus |
|---|---|---|
| Feature-Dev | structured prompts | feature implementation workflow |
| Spec-Kit | spec-first development | requirements-driven coding |
| GSD | context engineering | reliable prompt sessions |
| OpenAgentsControl | agent orchestration | multi-agent execution |
| Superpowers | engineering skill library | structured developer practices |
| **Feature-Driven-Flow** | workflow governance | deterministic development process |

Most frameworks focus on:

- prompts
- agents
- skills

FDF focuses on **process governance**.

---

# Genuine Innovations of Feature-Driven-Flow

## Rule Matrix Compilation

Policies are compiled into a deterministic execution artifact.

Few frameworks treat workflow governance as a **compiled configuration**.

---

## Governance-First Design

Instead of agents or prompts, the framework prioritizes **process control**.

The workflow behaves like a policy-driven system.

---

## Asynchronous Development Workflows

FDF allows workflows to be paused and resumed across sessions and participants.

This enables collaboration between:

- developers
- multiple AI agents
- asynchronous teams

---

## Markdown-Native Infrastructure

The framework intentionally avoids a runtime orchestration engine.

Everything is defined using:

- Markdown
- JSON schemas
- repository artifacts

This makes workflows:

- versionable
- auditable
- portable

---

# Conclusion

Feature-Driven-Flow represents a shift in thinking about AI-assisted development.

Instead of treating AI coding as a prompt-driven interaction, FDF treats it as a **governed engineering workflow**.

Its key contributions include:

- rule-compiled workflow policies
- deterministic phase execution
- asynchronous collaboration artifacts
- portable workflow instructions
- a modular micro-core architecture

As AI development workflows become more complex and involve multiple agents and contributors, frameworks like FDF may play an increasingly important role in ensuring **reproducibility, traceability, and governance**.
