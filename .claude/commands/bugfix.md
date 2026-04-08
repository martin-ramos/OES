---
description: Bug fix pipeline. Each phase runs as an isolated subagent via Agent tool.
---

# Bugfix Orchestrator

**Task**: $ARGUMENTS

Read `.claude/protocols/orchestrator.md` before starting.

---

## Setup

1. Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`
2. Set `security_active = false`
3. If bug touches auth / HTTP inputs / secrets / network / PII → set `security_active = true`

---

## F1 — bug-fixer

1. Read `.claude/agents/bug-fixer.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {bug-fixer.md content}

   TASK: $ARGUMENTS

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → if security_flag=YES: set security_active=true. Store files_modified, F1.for_next.

---

## F2 — test-engineer

1. Read `.claude/agents/test-engineer.md`
2. Invoke **Agent tool**:
   ```
   {test-engineer.md content}

   TASK: Write regression test for: $ARGUMENTS
   Note: test must FAIL if the fix is reverted.

   BUG-FIXER CONTEXT:
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

   TASK: Security review for bug fix: $ARGUMENTS

   FIX CONTEXT:
   {F1.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - verdict=REQUIERE_CAMBIOS → **halt pipeline**. Report F3.blockers to user.
   - verdict=APROBADO → continue.

---

## F4 — code-reviewer FINAL (mandatory)

1. Read `.claude/agents/code-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {code-reviewer.md content}

   TASK: Final review of bug fix: $ARGUMENTS

   CONTEXT:
   {F2.for_next}
   {F3.for_next if F3 ran}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - verdict=RECHAZADO → retry (max 2): re-invoke F1 with blockers, re-run F4
   - verdict=APROBADO or APROBADO_CON_OBSERVACIONES → continue

---

## F5 — documentation-writer (only if fix changes endpoint or documented behavior)

1. Read `.claude/agents/documentation-writer.md`
2. Invoke **Agent tool**:
   ```
   {documentation-writer.md content}

   TASK: Document fix for: $ARGUMENTS
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

   TASK: Commit bug fix for: $ARGUMENTS
   CONTEXT: {F5.for_next if F5 ran, else F4.for_next}

   {HANDOFF_PROTOCOL}
   ```

---

## Final Report

```
## Bugfix completed: $ARGUMENTS

| Phase | Agent | Status | Verdict |
|---|---|---|---|
| F1 | bug-fixer | {status} | N/A |
| F2 | tests | {status} | N/A |
| F3 | security | {ran/skipped} | {verdict or N/A} |
| F4 | review FINAL | {status} | {verdict} |
| F5 | docs | {ran/skipped} | N/A |
| F6 | commit | {status} | N/A |

Modified files: {list}
```
