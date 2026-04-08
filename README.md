# OES — Orchestrated Engineering Standard

OES is a lightweight engineering governance framework designed for disciplined, performance-aware, SOLID-driven development with mandatory final review and measurable quality.

Works with Claude Code, OpenCode, and Codex CLI.

---

## What OES Is

OES is not a methodology. It is a **governance layer** that sits between you and the LLM, enforcing:

- Structured execution on every task
- Visible classification before any action
- Explicit review gate before completion
- Measurable quality score (EQI 0–100)
- Persistent memory across sessions via Engram

It operates through a pipeline of specialized agents, each with a single responsibility, that activate based on the task type and risk profile.

---

## Agent Roster

| Agent | Role | Activates on |
|---|---|---|
| `task-classifier` | Classifies task type, detects security risk | `/work` entry point |
| `software-architect` | Designs solution before implementation | Multi-layer features, schema changes |
| `senior-developer` | Implements the design | All implementation tasks |
| `bug-fixer` | Root cause fix, minimal change | `/bugfix` |
| `refactorer` | Structure improvement, no behavior change | `/refactor` |
| `test-engineer` | Writes JUnit 5 + MockK tests | `/test`, post-implementation |
| `code-reviewer` | Final verdict: APPROVED / OBS / REJECTED | End of every pipeline |
| `security-reviewer` | Targets auth, secrets, network, PII | Conditional — auto-activated on risk |
| `documentation-writer` | Updates docs only when relevant | Post-feature, post-deploy |
| `commit-writer` | Atomic commits, Conventional Commits | `/commit` |
| `aws-architect` | ECS Fargate, ECR, ALB, cost-aware infra | AWS/infrastructure tasks |
| `pr-reviewer` | Full PR review before merge | `/review-pr` |

### Agent Pipeline (example: `/feature`)

```
task-classifier → software-architect → senior-developer → test-engineer
→ [security-reviewer] → code-reviewer FINAL → documentation-writer → commit-writer
```

Every pipeline ends with `code-reviewer` FINAL. No exceptions.

---

## Engram — Persistent Memory

Engram is OES's memory layer. It survives across sessions, compactions, and machines.

| Call | When |
|---|---|
| `mem_context` | Session start — loads prior decisions, conventions, alerts |
| `mem_save` | Immediately after any architectural decision |
| `mem_session_summary` | Session end — mandatory |

**What gets stored**: architectural decisions, confirmed patterns, project-specific gotchas, trade-offs.
**What never gets stored**: code, diffs, task lists, intermediate reasoning.

Engram is cloud-synced. On a new machine, `mem_context` restores everything from the previous session immediately.

---

## Benefits

### Consistency
Every task follows the same pipeline regardless of who runs it. The LLM cannot skip review, skip classification, or skip the security check when the task qualifies.

### Institutional memory
Engram stores decisions durably. The next session — on any machine — starts with full context. No re-explaining architecture, no re-stating conventions, no repeating "we use constructor injection here."

### Visible execution
Every task is classified before execution. You see exactly which agents activate and why. Nothing happens silently.

### Forced quality gate
`code-reviewer` FINAL is mandatory at the end of every pipeline. The EQI score is explicit, not implicit. Technical debt doesn't accumulate silently.

### Security by default
`security-reviewer` activates automatically when the task touches auth, external inputs, secrets, network, or PII. It doesn't require the developer to remember to ask for it.

### Safe cloud execution
`aws-architect` never executes cloud changes without explicit confirmation. Every infra proposal includes cost impact (Low / Medium / High). Terraform is the default — no raw AWS CLI in production flows.

### Token efficiency
The Compact Prompt Format (`@std`, `@perf`, `@rel`, `@end`) compresses repeated principles into references. Agent files are loaded lazily, not pre-loaded. The orchestrator retains only structured HANDOFF blocks between phases — not full agent output.

### Portable
One framework, three tools: Claude Code, OpenCode, Codex CLI. Same principles, same commands, same quality bar.

---

## Limitations

### Requires Engram
Without Engram, OES loses its memory layer. Sessions start cold. The framework still works, but decisions get repeated across sessions and context is lost on compaction.

### Overhead on trivial tasks
A one-line bug fix doesn't need an architect, a test engineer, and a commit-writer. The `/bugfix` pipeline is optimized for this, but OES has more ceremony than a bare LLM interaction. For micro-edits, the overhead is real.

### Agent coordination latency
Multi-phase pipelines run agents sequentially as isolated subagents. Each phase is a separate LLM call. Complex features (`/feature`) can involve 5–7 agent phases. This takes longer than a single prompt.

### Stack specificity in some agents
Several agents (`code-reviewer`, `pr-reviewer`, `senior-developer`) have Kotlin + Spring Boot conventions baked in. Teams on other stacks need to adapt these definitions before using OES at full fidelity.

### Codex support is newer
Claude Code integration is the most mature. OpenCode is second. Codex (`AGENTS.md`) was added in v1.4.0 and has less real-world validation.

### EQI is LLM-assigned
The quality score (0–100) is produced by `code-reviewer`, not a static analyzer. It reflects structured evaluation, but it is not a deterministic metric. Two runs may produce slightly different scores on the same code.

---

## Tool Support

| Tool | Config file | Directory |
|---|---|---|
| Claude Code | `.claude/CLAUDE.md` | `.claude/` |
| OpenCode | `.opencode/OES.md` | `.opencode/` |
| Codex CLI | `AGENTS.md` (root) | `.opencode/` |

---

## Compact Prompt Format (v1.4.0)

OES uses a compact notation to minimize token overhead across all tools:

| Token | Meaning |
|---|---|
| `@std` | Clean Code + SOLID + Security baseline |
| `@perf` | Performance constraints (Big-O, hot paths, no recompute) |
| `@rel` | Reliability constraints (error handling, invariants, state) |
| `@end` | Mandatory review gate + EQI score |
| `?` | Conditional — apply when relevant |
| `→` | Sequential flow |
| `\|` | Set or alternative |

---

## Commands

| Command | Pipeline |
|---|---|
| `/work <task>` | Auto-classify → correct pipeline |
| `/feature <task>` | explore → spec → design → plan → impl → verify |
| `/bugfix <bug>` | root-cause → fix → verify |
| `/refactor <goal>` | classify → apply @std → verify no behavior change |
| `/review` | eval [@std, @perf, @rel] → EQI |
| `/review-pr [#]` | compile → diff → commits → scope → verdict |
| `/test <target>` | write tests → run → verify coverage |
| `/deploy <task>` | aws-architect → security → execute → verify |
| `/sdd <req>` | explore → spec → design → plan → impl → verify |
| `/commit` | stage → conventional commit → confirm |

---

## Modes

| Mode | When to activate |
|---|---|
| `standard` | Default — always active |
| `performance-strict` | Hot paths, high-throughput services, O(n) must be declared |
| `high-reliability` | Critical systems, financial logic, data integrity requirements |

---

## Quick Links

- [QUICKSTART.md](QUICKSTART.md) — Installation and first use
- [ARCHITECTURE.md](ARCHITECTURE.md) — Layered model and execution flow
- [ENGRAM.md](ENGRAM.md) — Memory system reference
- [MANIFESTO.md](MANIFESTO.md) — Design philosophy

---

Version: v1.4.0
