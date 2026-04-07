# OES — Claude Code Integration

OES (Orchestrated Engineering Standard) es el sistema de agentes y pipelines de desarrollo.

## Engram (obligatorio)

- **Session start**: llamar `engram_briefing` siempre
- **Decisiones arquitectónicas**: llamar `engram_remember` inmediatamente al tomar decisiones
- **Session end**: llamar `engram_checkpoint`

## Comandos disponibles

| Comando | Descripción |
|---|---|
| `/work <texto>` | Agente general: clasifica y delega al pipeline correcto |
| `/feature <texto>` | Nueva funcionalidad completa |
| `/bugfix <texto>` | Corrección de bug |
| `/refactor <texto>` | Refactor sin cambio de comportamiento |
| `/review` | Revisión de cambios actuales |
| `/review-pr [N]` | Revisión completa de un Pull Request |
| `/commit` | Preparar y commitear cambios |

## Skill: pr-reviewer

El `pr-reviewer` es un Senior Software Engineer especializado en revisión de PRs.

**Activa automáticamente cuando**: se usa `/review-pr`

**Verifica**:
1. Compilación (si falla → RECHAZADO automático)
2. Errores y malas prácticas
3. Uso de patrones y arquitectura
4. Legibilidad del código
5. Archivos fuera del scope del PR
6. Calidad de mensajes de commit

**Veredicto**: APROBADO | APROBADO CON OBSERVACIONES | RECHAZADO

**Restricción**: un PR a la vez.

## Agents

Los agentes están en `.claude/agents/`. Claude Code los carga automáticamente.

- `pr-reviewer.md` — Senior Software Engineer para revisión de PRs
