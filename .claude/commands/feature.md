---
description: Pipeline completo para implementar una nueva funcionalidad. Ejecuta cada fase inline adoptando roles declarativos (sin subagentes nativos): software-architect → senior-developer → code-reviewer (self-review) → senior-developer (fix si aplica) → test-engineer → security-reviewer (si aplica) → code-reviewer FINAL → documentation-writer → commit-writer.
---

Tarea: $ARGUMENTS

Lee y ejecuta el pipeline definido en `.claude/teams/pipelines/feature.md`.
Roles embebidos en el pipeline. Referencia de estándares: `.claude/teams/AGENTS.md`.

**Instrucción**: adopta cada rol en secuencia. NO uses el Agent tool — ejecútalas inline.
