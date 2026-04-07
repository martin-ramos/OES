# Pipeline: feature

**Modelo**: Claude ejecuta cada fase inline. NO usar Agent tool para fases del pipeline.
**Referencia de roles completos**: `.claude/teams/AGENTS.md`

---

## Fase 0 — Evaluación inicial

¿Toca auth / inputs HTTP / secretos / red / PII? → activar security-reviewer en Fase 5.
Anuncia el pipeline completo que se ejecutará.

---

## Fase 1 — software-architect

Diseña solución técnica mínima. **No implementar código.** Explorar archivos relevantes antes de proponer.
- Checklist: encaja en capas (controller→service→repo), reutiliza existente, schema BD si aplica, breaking changes evaluados, flag seguridad indicado
- Produce: componentes afectados, contratos propuestos, schema BD, config necesaria, flag seguridad, decisiones

Avanza: diseño suficientemente claro para implementar sin ambigüedades.

---

## Fase 2 — senior-developer

Implementa el diseño de Fase 1. Lee archivos antes de editarlos.
- Checklist: `./gradlew classes` pasa, sin secretos, `val`>`var`, no `!!`, constructor injection, lógica en services, DTOs en controllers, funciones <20 líneas
- Produce: implementación + archivos modificados + notas para tests y review

Avanza: `./gradlew classes` pasa y la implementación cubre el diseño.

---

## Fase 3 — code-reviewer (self-review)

Veredicto: **APROBADO** | **APROBADO CON OBSERVACIONES** | **RECHAZADO**.
Issues: [BLOQUEANTE] / [MEJORA] / [SUGERENCIA]. RECHAZADO requiere ≥1 BLOQUEANTE.
- RECHAZADO → Fase 3b
- APROBADO / APROBADO CON OBSERVACIONES → Fase 4

---

## Fase 3b — senior-developer (corrección post self-review)

*Solo si Fase 3 = RECHAZADO.* Corrige únicamente items BLOQUEANTES. No amplía scope.
Avanza a Fase 4 directamente (sin re-ejecutar self-review).

---

## Fase 4 — test-engineer

Tests JUnit 5 + MockK en `src/test/kotlin/com/appswoopa/`. Happy path + ≥1 caso de error/borde.
`@SpringBootTest` solo si requiere contexto Spring completo. No testear frameworks.
Produce: tests creados + `./gradlew test` OK.

Avanza: `./gradlew test` pasa.

---

## Fase 5 — security-reviewer (condicional)

*Solo si toca auth / inputs HTTP / secretos / red / integraciones / PII.*
Veredicto: APROBADO | REQUIERE CAMBIOS (solo si CRÍTICO/ALTO).
Si REQUIERE CAMBIOS: senior-developer corrige, luego continuar.

---

## Fase 6 — code-reviewer FINAL (obligatorio)

Revisión final sobre implementación + tests + fixes previos.
Veredicto: APROBADO | APROBADO CON OBSERVACIONES | RECHAZADO.
Si RECHAZADO: senior-developer corrige BLOQUEANTEs y re-ejecutar esta fase.

**Pipeline NO avanza hasta APROBADO o APROBADO CON OBSERVACIONES.**

---

## Fase 7 — documentation-writer

Actualiza `docs/API_ENDPOINTS.md` si hay endpoints nuevos/modificados.
Actualiza `CLAUDE.md` § Configuration si hay variables de entorno nuevas.

---

## Fase 8 — commit-writer

Commits atómicos Conventional Commits. Mostrar plan y esperar confirmación antes de ejecutar.

---

## Resumen final obligatorio

```
## Feature completado: [nombre]
### Pipeline ejecutado
- F1 architect: [completado]
- F2 developer: [completado]
- F3 self-review: [veredicto] [¿disparó F3b?]
- F4 tests: [OK - N tests]
- F5 security: [veredicto | N/A]
- F6 review FINAL: [veredicto]
- F7 docs: [completado]
- F8 commit: [completado | pendiente confirmación]
### Archivos modificados: [lista]
### Tests creados: [lista]
```
