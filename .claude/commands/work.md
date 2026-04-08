---
description: Auto-classify task and delegate to the correct pipeline. Runs task-classifier as isolated subagent, then executes the corresponding pipeline.
---

# Work Orchestrator

**Task**: $ARGUMENTS

Read `.claude/protocols/orchestrator.md` before starting.

---

## Setup

Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`

---

## F1 — task-classifier

1. Read `.claude/agents/task-classifier.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {task-classifier.md content}

   TASK: $ARGUMENTS

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → extract from for_next:
   - `type`: feature | bug | refactor | documentation | review | deploy
   - `command`: the pipeline to run
   - `security_flag`: YES | NO
   - `reformulated_task`: cleaner task description

---

## F2 — Execute pipeline

Announce classification: "Classified as **{type}**. Running `/{command}` pipeline."

Execute the corresponding pipeline using the **reformulated_task** as input:

| Type | Action |
|---|---|
| feature | Load and execute `.claude/commands/feature.md` with reformulated_task |
| bug | Load and execute `.claude/commands/bugfix.md` with reformulated_task |
| refactor | Load and execute `.claude/commands/refactor.md` with reformulated_task |
| documentation | Single Agent: `.claude/agents/documentation-writer.md` with reformulated_task |
| review | Load and execute `.claude/commands/review.md` with reformulated_task |
| deploy | Load and execute `.claude/commands/deploy.md` with reformulated_task |

Pre-set `security_active` from F1.security_flag before running the sub-pipeline.

Do NOT re-invoke task-classifier. Classification runs exactly once.
