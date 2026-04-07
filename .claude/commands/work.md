---
description: Clasificar automáticamente la tarea y ejecutar el pipeline correcto. Adopta el rol task-classifier inline para determinar el tipo, luego ejecuta /feature, /bugfix, /refactor, /document o /review según corresponda. Sin subagentes nativos.
---

Tarea: $ARGUMENTS

Lee y ejecuta el pipeline definido en `.claude/teams/pipelines/work.md`.
Clasificador y roles embebidos en el pipeline. Referencia de estándares: `.claude/teams/AGENTS.md`.

**Instrucción**: clasifica inline, anuncia, ejecuta pipeline. NO uses el Agent tool.
