# Pipeline: review-pr — Phase Routing Table

Orchestration logic is in `.claude/commands/review-pr.md`.
Agent definitions are in `.claude/agents/`.

## Phase Map

| Phase | Agent | Agent File | Conditional |
|---|---|---|---|
| F1 | pr-reviewer | `.claude/agents/pr-reviewer.md` | always |
| F2 | security-reviewer | `.claude/agents/security-reviewer.md` | only if F1.security_flag=YES |

## Gates

- F1=BLOCKED (compilation failed) → stop immediately. Do not run F2.
- F2=REQUIERE_CAMBIOS → list corrections needed before merge.
