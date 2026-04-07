---
description: Deploy a AWS producción (ECS Fargate). Para nuevo microservicio, redeploy de imagen existente, o cambios de infraestructura. Siempre al menor costo posible.
---

Tarea de deploy: $ARGUMENTS

Lee y ejecuta el pipeline definido en `.claude/teams/pipelines/deploy.md`.
Rol aws-architect y roles embebidos en el pipeline. Gotchas e infra de Travelian en `.claude/agents/aws-architect.md`.

**Instrucción**: adopta aws-architect inline, anuncia el plan, ejecuta pipeline. NO uses el Agent tool.
Prioridad absoluta: **menor costo posible** sin sacrificar disponibilidad mínima.
