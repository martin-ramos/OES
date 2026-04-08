---
description: Code review. Runs code-reviewer as subagent. Adds security-reviewer automatically if needed.
---

# Review Orchestrator

**Target**: $ARGUMENTS (or current git diff if not specified)

Read `.claude/protocols/orchestrator.md` before starting.

---

## Setup

1. Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`
2. Assess code: if it touches auth / HTTP inputs / secrets / network / PII → set `security_active = true`
3. Announce: "Running code-reviewer{+ security-reviewer if security_active}."

---

## F1 — code-reviewer

1. Read `.claude/agents/code-reviewer.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {code-reviewer.md content}

   TASK: Review: $ARGUMENTS
   If no target specified, review current git diff.

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → if security_flag=YES: set security_active=true. Store F1.verdict, F1.for_next.

---

## F2 — security-reviewer (only if security_active=true)

1. Read `.claude/agents/security-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {security-reviewer.md content}

   TASK: Security review: $ARGUMENTS

   CODE REVIEW CONTEXT:
   {F1.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → store F2.verdict.

---

## Final Report

```
## Review completed: $ARGUMENTS

| Reviewer | Verdict |
|---|---|
| code-reviewer | {F1.verdict} |
| security-reviewer | {F2.verdict or N/A} |

### Issues
{consolidated from F1 and F2 summaries}

### Action required
{none | specific corrections before merge}
```
