# Pipeline: feature — Phase Routing Table

Orchestration logic is in `.claude/commands/feature.md`.
Agent definitions are in `.claude/agents/`.

## Phase Map

| Phase | Agent | Agent File | Conditional |
|---|---|---|---|
| F1 | software-architect | `.claude/agents/software-architect.md` | always |
| F2 | senior-developer | `.claude/agents/senior-developer.md` | always |
| F3 | code-reviewer (self-review) | `.claude/agents/code-reviewer.md` | always |
| F3b | senior-developer (fix) | `.claude/agents/senior-developer.md` | only if F3=RECHAZADO |
| F4 | test-engineer | `.claude/agents/test-engineer.md` | always |
| F5 | security-reviewer | `.claude/agents/security-reviewer.md` | only if security_flag=YES |
| F6 | code-reviewer FINAL | `.claude/agents/code-reviewer.md` | always |
| F7 | documentation-writer | `.claude/agents/documentation-writer.md` | always |
| F8 | commit-writer | `.claude/agents/commit-writer.md` | always |

## Gates

- F3=RECHAZADO → run F3b, then F4
- F5=REQUIERE_CAMBIOS → halt pipeline
- F6=RECHAZADO → retry loop (max 2): re-invoke F2 with blockers, re-run F6
