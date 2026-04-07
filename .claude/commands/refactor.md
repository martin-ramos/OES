---
description: Pipeline para refactorizar código sin cambiar comportamiento. Ejecuta cada fase inline adoptando roles declarativos (sin subagentes nativos): [verificar tests] → refactorer → test-engineer → security-reviewer (si aplica) → code-reviewer FINAL → documentation-writer → commit-writer. Precondición: tests existentes o se crean antes de refactorizar.
---

Objetivo del refactor: $ARGUMENTS

Lee y ejecuta el pipeline definido en `.claude/teams/pipelines/refactor.md`.
Roles embebidos en el pipeline. Referencia de estándares: `.claude/teams/AGENTS.md`.

**Instrucción**: adopta cada rol en secuencia. NO uses el Agent tool — ejecútalas inline.
