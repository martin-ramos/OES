# Pipeline: bugfix

**Modelo**: Claude ejecuta cada fase inline. NO usar Agent tool.
**Referencia de roles completos**: `.claude/teams/AGENTS.md`

---

## Fase 0 — Evaluación inicial

¿El bug está en código que toca auth / inputs externos / secretos / red? → activar security-reviewer en Fase 3.
Anuncia el pipeline que se ejecutará.

---

## Fase 1 — bug-fixer

Identifica causa raíz (no solo síntoma). Fix mínimo. Lee código adyacente antes de editar.
- Checklist: causa raíz identificada, fix mínimo, `./gradlew classes` pasa, sin cambios no relacionados
- Produce: causa raíz + fix aplicado + archivos modificados + cómo verificar + posibles regresiones

Avanza: `./gradlew classes` pasa y causa raíz identificada y resuelta.

---

## Fase 2 — test-engineer (test de regresión)

Test que habría detectado el bug. **Debe fallar si se revierte el fix.**
Produce: test de regresión + `./gradlew test` OK.

Avanza: `./gradlew test` pasa.

---

## Fase 3 — security-reviewer (condicional)

*Solo si el bug está en código con inputs externos, auth, secretos o datos sensibles.*
Verifica que el fix no introduce ni deja vulnerabilidades.
Veredicto: APROBADO | REQUIERE CAMBIOS (solo si CRÍTICO/ALTO).
Si REQUIERE CAMBIOS: bug-fixer corrige antes de continuar.

---

## Fase 4 — code-reviewer FINAL (obligatorio)

Evalúa: ¿fix resuelve causa raíz? ¿no introduce regresiones? ¿test prueba lo correcto?
Veredicto: APROBADO | APROBADO CON OBSERVACIONES | RECHAZADO.
Si RECHAZADO: bug-fixer corrige BLOQUEANTEs y re-ejecutar esta fase.

**Pipeline NO avanza hasta APROBADO o APROBADO CON OBSERVACIONES.**

---

## Fase 5 — documentation-writer

Actualiza docs solo si el fix modifica un endpoint o comportamiento documentado.
Para fixes internos sin cambio de contrato: omitir esta fase.

---

## Fase 6 — commit-writer

Commits atómicos Conventional Commits. Mostrar plan y esperar confirmación.

---

## Resumen final obligatorio

```
## Bug fix completado: [descripción]
### Causa raíz: [explicación]
### Pipeline ejecutado
- F1 bug-fixer: [completado]
- F2 tests: [OK - N tests]
- F3 security: [veredicto | N/A]
- F4 review FINAL: [veredicto]
- F5 docs: [completado | omitido — razón]
- F6 commit: [completado | pendiente confirmación]
### Archivos modificados: [lista]
### Test de regresión: [archivo:método]
```
