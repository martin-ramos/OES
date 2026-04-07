# Pipeline: work

**Propósito**: clasificar automáticamente la tarea y ejecutar el pipeline correcto.
**Modelo**: Claude adopta task-classifier inline. NO usar Agent tool.

---

## Fase 1 — task-classifier

Analiza el prompt, determina tipo y si requiere security-reviewer.

| Tipo | Señales |
|---|---|
| feature | "agregar", "crear", "implementar", "nuevo", funcionalidad que no existe |
| bug | "error", "falla", "excepción", "stacktrace", comportamiento que debería funcionar |
| refactor | "limpiar", "simplificar", "extraer", sin cambio de comportamiento |
| documentation | "documentar", "actualizar docs" |
| review | "revisar", "¿está bien?", "auditar" |
| deploy | "deployar", "subir a producción", "ECS", "AWS", "redeploy", "nueva imagen", "infra", "Fargate", "ECR" |

Security-reviewer si: auth, inputs HTTP, secretos, red saliente, PII.
En tipo `deploy`: security-reviewer SIEMPRE activo.

Produce:
```
**Tipo**: [tipo] | **Comando**: /[comando] | **Security**: [Sí/No — razón]
**Tarea reformulada**: [requerimiento claro y accionable]
```

---

## Fase 2 — Anuncio y ejecución

Anuncia la clasificación y ejecuta el pipeline correspondiente con la tarea reformulada:

| Tipo | Pipeline |
|---|---|
| feature | `.claude/teams/pipelines/feature.md` |
| bug | `.claude/teams/pipelines/bugfix.md` |
| refactor | `.claude/teams/pipelines/refactor.md` |
| documentation | rol documentation-writer directamente (ver `.claude/teams/AGENTS.md`) |
| review | rol code-reviewer + security-reviewer si aplica (ver `.claude/teams/AGENTS.md`) |
| deploy | `.claude/teams/pipelines/deploy.md` |

No volver a invocar task-classifier. Solo se ejecuta una vez al inicio.
