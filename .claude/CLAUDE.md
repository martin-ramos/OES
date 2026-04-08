# OES — Claude Code

Stack: Kotlin + Spring Boot. Pipelines run as **isolated subagents** (Agent tool) — never inline.

## Engram
- Start: `mem_context` — load previous context
- Decisions: `mem_save` immediately
- End: `mem_session_summary`

## Commands

| Command | Purpose |
|---|---|
| `/work <task>` | Auto-classify → correct pipeline |
| `/feature <task>` | New functionality |
| `/bugfix <bug>` | Bug fix |
| `/refactor <goal>` | Structural improvement |
| `/review` | Code review |
| `/review-pr [#]` | Full PR review |
| `/test <target>` | Write tests |
| `/document <topic>` | Update docs |
| `/commit` | Atomic commits |
| `/deploy <task>` | AWS ECS Fargate |
| `/sdd <req>` | Spec Driven Development |
| `/explore <topic>` | Explore codebase |

## Architecture

- Agents: `.claude/agents/` — loaded lazily, one per pipeline phase
- Pipelines: `.claude/pipelines/` — phase routing tables
- Protocol: `.claude/protocols/handoff.md` + `.claude/protocols/orchestrator.md`
- Standards: `.claude/AGENTS.md`
