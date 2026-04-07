---
description: Pipeline SDD de implementación y validación, arrancando desde un Proposal o Spec aprobado. Ejecuta inline: Spec Writer + Designer → merge → Task Planner → Implementer → self-review → Human Gate 2 → Verifier → Archiver. Usar después de /explore cuando el usuario ya aprobó la propuesta.
---

Spec o Proposal aprobado: $ARGUMENTS

Lee y ejecuta los pipelines en secuencia:
1. `.claude/sdd/pipelines/design.md` — produce Spec + Design + Merged output
2. `.claude/sdd/pipelines/implementation.md` — produce Implementation Plan + código + Human Gate 2
3. `.claude/sdd/pipelines/validation.md` — produce tests + verification + archive _(después de Human Gate 2)_

**Instrucción de ejecución**:
- Si $ARGUMENTS contiene un Proposal aprobado: úsalo directamente como input del pipeline de diseño
- Si $ARGUMENTS es solo una descripción: actuar como si viniera de un /explore previo con esa descripción
- Adopta cada rol inline según los pipelines — NO uses el Agent tool
- Detente en Human Gate 2 y espera respuesta explícita del usuario antes de continuar a validación
- Perfiles en `.claude/sdd/agents/`, templates en `.claude/sdd/artifacts/templates/`
