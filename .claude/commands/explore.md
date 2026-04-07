---
description: Pipeline SDD corto de exploración y propuesta. Ejecuta inline: Explorer → Proposer → Human Gate 1. Produce Exploration Report + Proposal y espera aprobación humana. Usar antes de /implement-sdd o para evaluar un requerimiento sin comprometerse a implementar.
---

Requerimiento: $ARGUMENTS

Lee y ejecuta el pipeline definido en `.claude/sdd/pipelines/exploration.md`.

**Instrucción de ejecución**:
- Paso 1: adopta rol Explorer (`.claude/sdd/agents/explorer.md`) — explora el repo y produce Exploration Report
- Paso 2: adopta rol Proposer (`.claude/sdd/agents/proposer.md`) — produce Proposal
- Human Gate 1: presenta el Proposal y detente esperando respuesta del usuario
- NO uses el Agent tool — ejecución inline
- Explorar máximo 5-8 archivos del proyecto para mantener tokens bajos
