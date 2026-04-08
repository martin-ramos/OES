---
description: Write and run tests. Runs test-engineer as isolated subagent.
---

# Test Orchestrator

**Target**: $ARGUMENTS

---

## Setup

Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`

---

## F1 — test-engineer

1. Read `.claude/agents/test-engineer.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {test-engineer.md content}

   TASK: Write tests for: $ARGUMENTS

   Context:
   - Service → unit tests with MockK
   - Controller → @WebMvcTest
   - Repository with custom @Query → @DataJpaTest
   - Specific behavior → focused tests

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → report test results to user.
