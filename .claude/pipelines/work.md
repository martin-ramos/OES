# Pipeline: work — Routing Table

Orchestration logic is in `.claude/commands/work.md`.

## Phase Map

| Phase | Agent | Agent File |
|---|---|---|
| F1 | task-classifier | `.claude/agents/task-classifier.md` |
| F2 | delegate to sub-pipeline | determined by F1 output |

## Routing

| Classification | Sub-pipeline |
|---|---|
| feature | `.claude/commands/feature.md` |
| bug | `.claude/commands/bugfix.md` |
| refactor | `.claude/commands/refactor.md` |
| documentation | single Agent: `.claude/agents/documentation-writer.md` |
| review | `.claude/commands/review.md` |
| deploy | `.claude/commands/deploy.md` |

## Classification Signals

| Type | Signals |
|---|---|
| feature | "add", "create", "implement", "new", functionality that doesn't exist |
| bug | "error", "fail", "exception", "stacktrace", behavior that should work but doesn't |
| refactor | "clean", "simplify", "extract", "reorganize", no behavior change |
| documentation | "document", "update docs", "readme" |
| review | "review", "check", "audit", "is this ok?" |
| deploy | "deploy", "production", "ECS", "AWS", "redeploy", "new image", "Fargate" |
