# OES — Claude Code Integration

OES (Orchestrated Engineering Standard) es el sistema de agentes, pipelines y estándares de desarrollo.

## Engram (obligatorio en cada sesión)

- **Session start**: llamar `engram_briefing` siempre — carga contexto, decisiones y alertas previas
- **Decisiones**: llamar `engram_remember` inmediatamente al tomar decisiones arquitectónicas o aprender convenciones
- **Session end**: llamar `engram_checkpoint`

## Cómo instalar en una máquina nueva

```bash
git clone https://github.com/martin-ramos/OES.git ~/OES

# Copiar al global de Claude Code (disponible en todos los proyectos)
cp -r ~/OES/.claude/commands/* ~/.claude/commands/
cp -r ~/OES/.claude/agents/* ~/.claude/agents/
```

Ver `QUICKSTART.md` para la guía completa incluyendo Engram y OpenCode.

## Comandos disponibles

| Comando | Descripción |
|---|---|
| `/work <texto>` | Agente general — carga Engram, clasifica y delega al pipeline correcto |
| `/feature <texto>` | Nueva funcionalidad completa (architect → developer → tests → review → docs → commit) |
| `/bugfix <texto>` | Corrección de bug (bug-fixer → tests → review → commit) |
| `/refactor <texto>` | Refactor sin cambio de comportamiento |
| `/review` | Revisión de cambios actuales (diff o archivos modificados) |
| `/review-pr [número]` | Revisión completa de un Pull Request — un PR a la vez |
| `/test <texto>` | Escribir y ejecutar tests |
| `/document <texto>` | Actualizar documentación técnica |
| `/sdd <texto>` | Crear Software Design Document |
| `/implement-sdd <archivo>` | Implementar un SDD existente |
| `/commit` | Preparar y commitear cambios con Conventional Commits |
| `/explore <texto>` | Explorar y entender el codebase |
| `/deploy <texto>` | Deploy a AWS ECS Fargate |

## Agentes (roles)

| Agente | Rol |
|---|---|
| `software-architect` | Diseña solución técnica mínima, no implementa |
| `senior-developer` | Implementa el diseño, verifica compilación |
| `bug-fixer` | Fix mínimo de causa raíz |
| `refactorer` | Mejora estructura sin cambiar comportamiento |
| `test-engineer` | Tests JUnit 5 + MockK, happy path + casos borde |
| `code-reviewer` | Veredicto APROBADO / APROBADO CON OBSERVACIONES / RECHAZADO |
| `pr-reviewer` | Senior SWE — review completo de PRs con compilación, diff y commits |
| `security-reviewer` | Riesgos de seguridad (auth, inputs, secretos, red, PII) |
| `documentation-writer` | Actualiza docs sin relleno |
| `commit-writer` | Commits atómicos Conventional Commits |
| `task-classifier` | Clasifica tipo de tarea y activa skills necesarios |
| `aws-architect` | Infraestructura AWS ECS Fargate, costo mínimo |

## Pipelines

Los pipelines están en `.claude/pipelines/`. Cada comando los referencia automáticamente.

| Pipeline | Secuencia |
|---|---|
| `feature` | architect → developer → self-review → [fix] → tests → [security] → review FINAL → docs → commit |
| `bugfix` | bug-fixer → tests → [security] → review FINAL → docs → commit |
| `refactor` | [tests previos] → refactorer → tests → [security] → review FINAL → docs → commit |
| `review-pr` | pr-reviewer (compilación + diff + commits) → [security] → veredicto final |
| `deploy` | aws-architect → security-reviewer → ejecución AWS CLI → verificación |
| `work` | engram_briefing → task-classifier → pipeline correspondiente → engram_checkpoint |

## Estándares (AGENTS.md)

Ver `AGENTS.md` para estándares de código, políticas y descripción completa de cada rol.

**Regla universal**: todos los pipelines terminan con `code-reviewer` FINAL obligatorio.
