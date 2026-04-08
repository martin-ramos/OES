# Handoff Protocol

Every subagent MUST end its response with this block.
The orchestrator retains ONLY this block — nothing outside it.

```
---HANDOFF---
phase: [id, e.g. "F1-architect"]
status: COMPLETED | BLOCKED | NEEDS_CORRECTION
files_modified: [comma-separated paths, or "none"]
files_created: [comma-separated paths, or "none"]
security_flag: YES | NO
verdict: [APROBADO | APROBADO_CON_OBSERVACIONES | RECHAZADO | REQUIERE_CAMBIOS | N/A]
blockers: NONE | [brief list]
summary: |
  [Max 150 words. Facts only: what changed, what was verified, key decisions.]
for_next: |
  [Max 100 words. What the next phase must know. This is the ONLY context passed forward.]
---END HANDOFF---
```

## Rules

- `summary` max 150 words. `for_next` max 100 words. Hard limits.
- Do NOT put implementation details outside the HANDOFF block.
- `status=BLOCKED` → human decision required before pipeline continues.
- `security_flag=YES` → orchestrator injects security-reviewer phase.
- `verdict=N/A` for implementation phases (architect, developer, fixer, refactorer, docs, commit).
- The orchestrator discards everything before `---HANDOFF---`.

## Role-specific `for_next` guidance

| Role | What to include in for_next |
|---|---|
| software-architect | Components to create/modify, key contracts, DB schema, security flag reason, trade-offs |
| senior-developer | Files modified/created, behaviors to test, non-obvious decisions for reviewer |
| bug-fixer | Root cause, files modified, how to verify fix, potential regressions |
| refactorer | Structural changes made, contracts preserved, test results |
| test-engineer | Test files created, behaviors covered, `gradlew test` result |
| code-reviewer | Verdict, blockers (if RECHAZADO), observations for next phase |
| security-reviewer | Verdict, critical/high findings for developer, security surface confirmed |
| documentation-writer | Docs updated, ready for commit |
| commit-writer | Commits created, git log summary |
| pr-reviewer | Verdict, blockers, security flag |
| task-classifier | Type, command, security decision, reformulated task |
| aws-architect | Plan, commands to execute, verification steps, cost estimate |
