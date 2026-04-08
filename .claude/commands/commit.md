---
description: Create atomic commits with Conventional Commits format. Shows plan and waits for confirmation.
---

# Commit Orchestrator

**Context**: $ARGUMENTS

---

## Setup

Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`

---

## F1 — commit-writer

1. Read `.claude/agents/commit-writer.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {commit-writer.md content}

   TASK: Analyze current changes and create atomic commits.
   Context: $ARGUMENTS

   {HANDOFF_PROTOCOL}
   ```
3. Present the commit plan to the user and wait for confirmation before executing.
