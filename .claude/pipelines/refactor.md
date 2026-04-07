# Pipeline: refactor

**Modelo**: Claude ejecuta cada fase inline. NO usar Agent tool.
**Precondición**: deben existir tests antes de refactorizar.
**Referencia de roles completos**: `.claude/teams/AGENTS.md`

---

## Fase 0 — Precondición: verificar tests

1. `./gradlew test` pasa
2. Identificar tests que cubren el código a refactorizar
3. Si no hay tests suficientes: adoptar rol test-engineer y crearlos primero

Avanza: tests de regresión existen y pasan.

---

## Fase 1 — refactorer

Mejora estructura sin cambiar comportamiento observable. Pasos pequeños, `./gradlew test` entre pasos.
No cambiar APIs públicas, contratos de endpoints, nombres de columnas BD. No agregar features.
Produce: cambios aplicados + qué mejoró + `./gradlew test` OK.

Avanza: `./gradlew test` pasa y refactor completo.

---

## Fase 2 — test-engineer (verificación)

Verifica que todos los tests preexistentes pasan. Si el refactor expuso nuevas oportunidades de test, las crea.
Produce: `./gradlew test` OK + tests adicionales si aplica.

Avanza: `./gradlew test` pasa con al menos los mismos tests que antes.

---

## Fase 3 — security-reviewer (condicional)

*Solo si el refactor tocó código con inputs externos, auth, secretos o datos sensibles.*
Veredicto: APROBADO | REQUIERE CAMBIOS (solo si CRÍTICO/ALTO).
Si REQUIERE CAMBIOS: refactorer corrige antes de continuar.

---

## Fase 4 — code-reviewer FINAL (obligatorio)

Evalúa: ¿mejoró la estructura? ¿contratos y comportamientos intactos? ¿nombres nuevos mejores?
Veredicto: APROBADO | APROBADO CON OBSERVACIONES | RECHAZADO.
Si RECHAZADO: refactorer corrige BLOQUEANTEs y re-ejecutar esta fase.

**Pipeline NO avanza hasta APROBADO o APROBADO CON OBSERVACIONES.**

---

## Fase 5 — documentation-writer

Solo si el refactor cambia nombres visibles externamente o comportamiento documentado.
Para refactors puramente internos: omitir esta fase.

---

## Fase 6 — commit-writer

Commits atómicos Conventional Commits. Mostrar plan y esperar confirmación.

---

## Resumen final obligatorio

```
## Refactor completado: [descripción]
### Problema estructural resuelto: [qué mejoró]
### Pipeline ejecutado
- F0 tests previos: [OK - N tests]
- F1 refactorer: [completado]
- F2 tests verificación: [OK - N tests]
- F3 security: [veredicto | N/A]
- F4 review FINAL: [veredicto]
- F5 docs: [completado | omitido — razón]
- F6 commit: [completado | pendiente confirmación]
### Archivos modificados: [lista]
### Comportamiento preservado: [confirmación explícita]
```
