---
description: Update technical documentation. Runs documentation-writer as isolated subagent.
---

# Document Orchestrator

**Topic**: $ARGUMENTS

---

## Setup

Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`

---

## F1 — documentation-writer

1. Read `.claude/agents/documentation-writer.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {documentation-writer.md content}

   TASK: Document: $ARGUMENTS

   Documentation map:
   - REST endpoint → docs/API_ENDPOINTS.md
   - Env var → CLAUDE.md
   - Task/scheduler flow → docs/FLUJO_TAREAS.md
   - Search flow → docs/FLUJO_BUSQUEDA_END_TO_END.md
   - Architecture → docs/ARCHITECTURE.md
   - Facebook GraphQL → docs/FACEBOOK_GRAPHQL_API.md

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → report updated files to user.
