---
description: Deploy to AWS ECS Fargate. Each phase runs as an isolated subagent via Agent tool. Minimum cost priority.
---

# Deploy Orchestrator

**Task**: $ARGUMENTS

Read `.claude/protocols/orchestrator.md` before starting.

---

## Setup

1. Read `.claude/protocols/handoff.md` → store as `HANDOFF_PROTOCOL`
2. Identify operation type: new microservice | redeploy existing | infra change

---

## F1 — aws-architect

1. Read `.claude/agents/aws-architect.md`
2. Invoke **Agent tool** (subagent_type: general-purpose):
   ```
   {aws-architect.md content}

   TASK: $ARGUMENTS

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF → store plan (F1.for_next). security_flag is always YES for deploy.

---

## F2 — security-reviewer (ALWAYS active for deploy)

Deploy always touches secrets, IAM, and network — security review is mandatory.

1. Read `.claude/agents/security-reviewer.md`
2. Invoke **Agent tool**:
   ```
   {security-reviewer.md content}

   TASK: Security review of deploy plan for: $ARGUMENTS

   PLAN:
   {F1.for_next}

   {HANDOFF_PROTOCOL}
   ```
3. Parse HANDOFF:
   - verdict=REQUIERE_CAMBIOS → re-invoke F1 with F2.blockers (max 2 retries), then re-run F2.
   - verdict=APROBADO → continue.

---

## F3 — AWS CLI execution (orchestrator, no subagent)

Execute the AWS CLI commands from F1.for_next in the correct order.
Announce each command before running. Stop and report if any command fails.

Typical order: ECR → build/push → secrets → target group → task def → service → DNS → alarms

---

## F4 — verification (orchestrator, no subagent)

Verify deployment success:
- `aws ecs describe-services` → check runningCount / desiredCount
- `aws logs tail` → check for startup errors
- Target group health check (if ALB)

Report: healthy | unhealthy (with diagnostics from F1.for_next verification section).

---

## F5 — documentation-writer (only for new microservice or architecture change)

1. Read `.claude/agents/documentation-writer.md`
2. Invoke **Agent tool**:
   ```
   {documentation-writer.md content}

   TASK: Document new deployment: $ARGUMENTS
   CONTEXT: {F1.for_next}

   {HANDOFF_PROTOCOL}
   ```

---

## Final Report

```
## Deploy completed: $ARGUMENTS

| Phase | Status |
|---|---|
| F1 | aws-architect | COMPLETED |
| F2 | security-review | APROBADO |
| F3 | AWS CLI execution | {OK/FAILED} |
| F4 | verification | {healthy/unhealthy} |
| F5 | docs | {ran/skipped} |

Cost estimate: {from F1 plan}
```
