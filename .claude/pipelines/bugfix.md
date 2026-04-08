# Pipeline: bugfix — Phase Routing Table

Orchestration logic is in `.claude/commands/bugfix.md`.
Agent definitions are in `.claude/agents/`.

## Phase Map

| Phase | Agent | Agent File | Conditional |
|---|---|---|---|
| F1 | bug-fixer | `.claude/agents/bug-fixer.md` | always |
| F2 | test-engineer | `.claude/agents/test-engineer.md` | always |
| F3 | security-reviewer | `.claude/agents/security-reviewer.md` | only if security_flag=YES |
| F4 | code-reviewer FINAL | `.claude/agents/code-reviewer.md` | always |
| F5 | documentation-writer | `.claude/agents/documentation-writer.md` | only if fix changes endpoint or documented behavior |
| F6 | commit-writer | `.claude/agents/commit-writer.md` | always |

## Gates

- F3=REQUIERE_CAMBIOS → halt pipeline
- F4=RECHAZADO → retry loop (max 2): re-invoke F1 with blockers, re-run F4
