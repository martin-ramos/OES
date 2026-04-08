---
description: New feature pipeline. Each phase runs as an isolated subagent via Agent tool.
---

# Feature Orchestrator

**Task**: $ARGUMENTS

Read `.claude/protocols/orchestrator.md` before starting.

---

## Setup

1. Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`
2. Set `security_active = false`
3. If task touches auth / HTTP inputs / secrets / network / PII → set `security_active = true`

---

## F1 — software-architect

1. Read `.claude/agents/software-architect.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {software-architect.md content}

   TASK: $ARGUMENTS

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → if security_flag=YES: set security_active=true. Store F1.for_next.

---

## F2 — senior-developer

1. Read `.claude/agents/senior-developer.md`
2. Invoke **Agent tool**:
   ```
   {senior-developer.md content}

   TASK: $ARGUMENTS

   ARCHITECT CONTEXT:
   {F1.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → update security_active if YES. Store files_modified, files_created, F2.for_next.

---

## F3 — code-reviewer (self-review)

1. Read `.claude/agents/code-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {code-reviewer.md content}

   TASK: Review implementation for: $ARGUMENTS

   IMPLEMENTATION CONTEXT:
   {F2.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - verdict=RECHAZADO → run F3b
   - verdict=APROBADO or APROBADO_CON_OBSERVACIONES → skip F3b

---

## F3b — senior-developer correction (only if F3=RECHAZADO)

1. Read `.claude/agents/senior-developer.md`
2. Invoke **Agent tool**:
   ```
   {senior-developer.md content}

   TASK: Fix blockers for: $ARGUMENTS
   BLOCKERS: {F3.blockers}

   CONTEXT: {F3.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → update F2.for_next with F3b.for_next.

---

## F4 — test-engineer

1. Read `.claude/agents/test-engineer.md`
2. Invoke **Agent tool**:
   ```
   {test-engineer.md content}

   TASK: Write tests for: $ARGUMENTS

   IMPLEMENTATION CONTEXT:
   {F3b.for_next if F3b ran, else F2.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → store F4.for_next.

---

## F5 — security-reviewer (only if security_active=true)

1. Read `.claude/agents/security-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {security-reviewer.md content}

   TASK: Security review for: $ARGUMENTS

   IMPLEMENTATION CONTEXT:
   {F2.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - verdict=REQUIERE_CAMBIOS → **halt pipeline**. Report F5.blockers to user.
   - verdict=APROBADO → continue.

---

## F6 — code-reviewer FINAL (mandatory)

1. Read `.claude/agents/code-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {code-reviewer.md content}

   TASK: Final review for: $ARGUMENTS

   CONTEXT:
   {F4.for_next}
   {F5.for_next if F5 ran}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - verdict=RECHAZADO → retry loop (max 2): re-invoke F2 with blockers, re-run F6
   - verdict=APROBADO or APROBADO_CON_OBSERVACIONES → continue

---

## F7 — documentation-writer

1. Read `.claude/agents/documentation-writer.md`
2. Invoke **Agent tool**:
   ```
   {documentation-writer.md content}

   TASK: Document changes for: $ARGUMENTS

   FILES CHANGED: {all files_modified + files_created}
   CONTEXT: {F6.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → store F7.for_next.

---

## F8 — commit-writer

1. Read `.claude/agents/commit-writer.md`
2. Invoke **Agent tool**:
   ```
   {commit-writer.md content}

   TASK: Commit changes for: $ARGUMENTS
   CONTEXT: {F7.for_next}

   {HANDOFF_PROTOCOL}
   ```

---

## Final Report

```
## Feature completed: $ARGUMENTS

| Phase | Agent | Status | Verdict |
|---|---|---|---|
| F1 | architect | {status} | N/A |
| F2 | developer | {status} | N/A |
| F3 | self-review | {status} | {verdict} |
| F3b | developer-fix | {ran/skipped} | N/A |
| F4 | tests | {status} | N/A |
| F5 | security | {ran/skipped} | {verdict or N/A} |
| F6 | review FINAL | {status} | {verdict} |
| F7 | docs | {status} | N/A |
| F8 | commit | {status} | N/A |

Modified files: {list}
Created files: {list}
```
