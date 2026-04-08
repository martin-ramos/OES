---
description: Refactor pipeline. Each phase runs as an isolated subagent via Agent tool. Precondition: tests must exist.
---

# Refactor Orchestrator

**Task**: $ARGUMENTS

Read `.claude/protocols/orchestrator.md` before starting.

---

## Setup

1. Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`
2. Set `security_active = false`

---

## F0 — verify tests (orchestrator only, no subagent)

Run `./gradlew test` directly.
- Tests pass → continue to F1
- Tests fail or none exist → **halt**. Tell user: "Run `/test` first to create coverage, then retry `/refactor`."

---

## F1 — refactorer

1. Read `.claude/agents/refactorer.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {refactorer.md content}

   TASK: $ARGUMENTS

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → if security_flag=YES: set security_active=true. Store files_modified, F1.for_next.

---

## F2 — test-engineer (verification)

1. Read `.claude/agents/test-engineer.md`
2. Invoke **Agent tool**:
   ```
   {test-engineer.md content}

   TASK: Verify all tests still pass after refactor of: $ARGUMENTS
   Note: do NOT change test behavior — only verify existing tests pass and add new ones if refactor exposes gaps.

   REFACTOR CONTEXT:
   {F1.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → store F2.for_next.

---

## F3 — security-reviewer (only if security_active=true)

1. Read `.claude/agents/security-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {security-reviewer.md content}

   TASK: Security review for refactor: $ARGUMENTS

   REFACTOR CONTEXT:
   {F1.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - verdict=REQUIERE_CAMBIOS → **halt pipeline**. Report blockers to user.
   - verdict=APROBADO → continue.

---

## F4 — code-reviewer FINAL (mandatory)

1. Read `.claude/agents/code-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {code-reviewer.md content}

   TASK: Final review of refactor: $ARGUMENTS
   Key criteria: structure improved, contracts preserved, tests pass.

   CONTEXT:
   {F2.for_next}
   {F3.for_next if F3 ran}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - verdict=RECHAZADO → retry (max 2): re-invoke F1 with blockers, re-run F4
   - verdict=APROBADO or APROBADO_CON_OBSERVACIONES → continue

---

## F5 — documentation-writer (only if externally visible names or documented behavior changed)

1. Read `.claude/agents/documentation-writer.md`
2. Invoke **Agent tool**:
   ```
   {documentation-writer.md content}

   TASK: Document refactor changes: $ARGUMENTS
   FILES CHANGED: {files_modified}
   CONTEXT: {F4.for_next}

   {HANDOFF_PROTOCOL}
   ```

---

## F6 — commit-writer

1. Read `.claude/agents/commit-writer.md`
2. Invoke **Agent tool**:
   ```
   {commit-writer.md content}

   TASK: Commit refactor: $ARGUMENTS
   CONTEXT: {F5.for_next if F5 ran, else F4.for_next}

   {HANDOFF_PROTOCOL}
   ```

---

## Final Report

```
## Refactor completed: $ARGUMENTS

| Phase | Agent | Status | Verdict |
|---|---|---|---|
| F0 | verify-tests | PASSED | N/A |
| F1 | refactorer | {status} | N/A |
| F2 | test-verification | {status} | N/A |
| F3 | security | {ran/skipped} | {verdict or N/A} |
| F4 | review FINAL | {status} | {verdict} |
| F5 | docs | {ran/skipped} | N/A |
| F6 | commit | {status} | N/A |

Modified files: {list}
```
