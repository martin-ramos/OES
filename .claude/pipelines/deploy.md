# Pipeline: deploy — Phase Routing Table

Orchestration logic is in `.claude/commands/deploy.md`.
Agent definitions are in `.claude/agents/`.
Security-reviewer is ALWAYS active in deploy (touches secrets, IAM, network).

## Phase Map

| Phase | Agent | Agent File | Conditional |
|---|---|---|---|
| F1 | aws-architect | `.claude/agents/aws-architect.md` | always |
| F2 | security-reviewer | `.claude/agents/security-reviewer.md` | ALWAYS |
| F3 | AWS CLI execution (orchestrator) | none — execute commands from F1 plan | always |
| F4 | verification (orchestrator) | none — run verify commands | always |
| F5 | documentation-writer | `.claude/agents/documentation-writer.md` | only for new microservice or architecture change |

## Gates

- F2=REQUIERE_CAMBIOS → re-invoke F1 with blockers (max 2), re-run F2
- F4=unhealthy → halt with diagnostics. Do not proceed.

## Operation Types

| Type | AWS CLI Order |
|---|---|
| New microservice | ECR → build/push → secrets → DB → logs → target group → ALB rule → task def → service → DNS → alarm |
| Redeploy | build/push → update-service --force-new-deployment → wait services-stable |
| Infra change | modify task def → update-service → wait services-stable |
