---
description: Full PR review. Runs pr-reviewer as isolated subagent. Adds security-reviewer automatically if needed.
---

# PR Review Orchestrator

**PR**: $ARGUMENTS

Read `.claude/protocols/orchestrator.md` before starting.

---

## Setup

1. Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`
2. If no PR number in $ARGUMENTS → list open PRs with `gh pr list` and ask user which to review.

---

## F1 — pr-reviewer

1. Read `.claude/agents/pr-reviewer.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {pr-reviewer.md content}

   TASK: Review PR: $ARGUMENTS

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - status=BLOCKED (compilation failed) → stop. Report failure to user. Do not continue.
   - security_flag=YES → run F2.
   - Store F1.verdict, F1.for_next.

---

## F2 — security-reviewer (only if F1.security_flag=YES)

1. Read `.claude/agents/security-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {security-reviewer.md content}

   TASK: Security review of PR: $ARGUMENTS

   PR REVIEW CONTEXT:
   {F1.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → store F2.verdict.

---

## Final Report

```
## PR Review: $ARGUMENTS

| Reviewer | Verdict |
|---|---|
| pr-reviewer | {F1.verdict} |
| security-reviewer | {F2.verdict or N/A} |

### Blockers
{F1.blockers + F2.blockers if any}

### Action required
{none | specific corrections before merge}
```
