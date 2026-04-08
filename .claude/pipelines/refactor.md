# Pipeline: refactor — Phase Routing Table

Orchestration logic is in `.claude/commands/refactor.md`.
Agent definitions are in `.claude/agents/`.
Precondition: tests must exist before F1 (F0 verifies).

## Phase Map

| Phase | Agent | Agent File | Conditional |
|---|---|---|---|
| F0 | verify-tests (orchestrator) | none — run `./gradlew test` directly | always |
| F1 | refactorer | `.claude/agents/refactorer.md` | always |
| F2 | test-engineer (verification) | `.claude/agents/test-engineer.md` | always |
| F3 | security-reviewer | `.claude/agents/security-reviewer.md` | only if security_flag=YES |
| F4 | code-reviewer FINAL | `.claude/agents/code-reviewer.md` | always |
| F5 | documentation-writer | `.claude/agents/documentation-writer.md` | only if externally visible names changed |
| F6 | commit-writer | `.claude/agents/commit-writer.md` | always |

## Gates

- F0=FAIL → halt. User must run `/test` first.
- F3=REQUIERE_CAMBIOS → halt pipeline
- F4=RECHAZADO → retry loop (max 2): re-invoke F1 with blockers, re-run F4
