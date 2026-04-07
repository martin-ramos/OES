---
description: Pipeline para corregir un bug. Ejecuta cada fase inline adoptando roles declarativos (sin subagentes nativos): bug-fixer → test-engineer → security-reviewer (si aplica) → code-reviewer FINAL → documentation-writer → commit-writer. Identifica causa raíz antes de aplicar fix.
---

Bug a corregir: $ARGUMENTS

Lee y ejecuta el pipeline definido en `.claude/teams/pipelines/bugfix.md`.
Roles embebidos en el pipeline. Referencia de estándares: `.claude/teams/AGENTS.md`.

**Instrucción**: adopta cada rol en secuencia. NO uses el Agent tool — ejecútalas inline.
