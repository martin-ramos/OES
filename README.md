# OES — Orchestrated Engineering Standard

OES is a lightweight engineering governance framework designed for disciplined, performance-aware, SOLID-driven development with mandatory final review and measurable quality.

It works with:
- Claude
- OpenCode
- Any LLM-assisted workflow

## What OES Provides

- Clean Code enforcement
- SOLID principles applied pragmatically
- Performance awareness (no premature optimization)
- Reliability controls for critical systems
- Cloud architecture governance (AWS-ready)
- Mandatory explicit final review
- Quality Score (0–100)
- Optional SDD mode
- Always-on Engram integration

## Core Philosophy

OES balances rigor and efficiency.

It avoids:
- Overengineering
- Narrative-heavy processes
- Role-play bloat
- Token waste

It guarantees:
- Structured execution
- Visible classification
- Explicit review gate
- Scalable discipline

## Quick Links

- QUICKSTART.md
- ARCHITECTURE.md
- MANIFESTO.md
- ENGRAM.md

## Cloud Governance (v1.2.0)

OES now includes:

- Cloud-agnostic infrastructure engine
- AWS / GCP / Azure provider abstraction
- Terraform as default IaC strategy
- Multi-environment infrastructure structure
- Controlled apply/destroy model
- Cost-awareness enforcement
- Mandatory confirmation before cloud execution

## PR Review Skill (v1.3.0)

OES now includes a `pr-reviewer` Senior Software Engineer skill:

- Verifies compilation before any analysis (auto-REJECTED if fails)
- Detects bad practices, missing patterns, poor readability
- Evaluates commit message quality (Conventional Commits)
- Flags files outside the PR's stated scope
- Works with Claude Code (`/review-pr`) and OpenCode
- Engram-integrated: stores recurring patterns as durable memory
- Reviews one PR at a time

## Tool Support

| Tool | Config file | Directory |
|---|---|---|
| Claude Code | `.claude/CLAUDE.md` | `.claude/` |
| OpenCode | `.opencode/OES.md` | `.opencode/` |
| Codex CLI | `AGENTS.md` | `.opencode/` |

## Compact Prompt Format (v1.4.0)

OES uses a compact notation to minimize token overhead:

- `@std` — Clean Code + SOLID + Security baseline
- `@perf` — Performance constraints
- `@rel` — Reliability constraints
- `@end` — Mandatory review gate + EQI score
- `?` — Conditional (apply when relevant)
- `→` — Sequential flow
- `|` — Set or alternative

Version: v1.4.0
