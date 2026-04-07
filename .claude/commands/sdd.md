---
description: Pipeline SDD completo (Spec Driven Development). Orquesta inline sin subagentes nativos: Explorer → Proposer → Human Gate 1 → Spec Writer + Designer → merge → Task Planner → Implementer → self-review → Human Gate 2 → Verifier → Archiver.
---

Requerimiento: $ARGUMENTS

Lee y ejecuta el pipeline completo definido en `.claude/sdd/pipelines/sdd-orchestrator.md`.

**Instrucción de ejecución**:
- Adopta cada rol SDD inline según el orchestrator — NO uses el Agent tool
- Los perfiles de cada rol están en `.claude/sdd/agents/`
- Los templates de artefactos están en `.claude/sdd/artifacts/templates/`
- Detente en cada Human Gate y espera respuesta explícita del usuario antes de continuar
- Pasa entre etapas solo el output estructurado del paso anterior, no el contexto completo
