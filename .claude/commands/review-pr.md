---
description: Revisión completa de un Pull Request. Verifica compilación, detecta malas prácticas, evalúa patrones, legibilidad, scope de archivos y calidad de commits. Revisa un PR a la vez.
---

Tipo de tarea: **PR REVIEW**

PR a revisar: $ARGUMENTS

---

## Fase 0 — Identificación

Si no se especificó número de PR:
```bash
gh pr list --limit 10
```
Preguntar cuál revisar. Procesar solo uno.

Anuncia: "Revisando PR #N: <título> (<origen> → <destino>)"

¿Toca auth / inputs HTTP / secretos / red / PII? → activar security-reviewer al final.

---

## Fase 1 — pr-reviewer

Ejecutar el agente `pr-reviewer` completo siguiendo su proceso y checklist.

Si no compila → **RECHAZADO** inmediato. Pipeline se detiene.

---

## Fase 2 (condicional) — security-reviewer

Solo si el PR toca: auth, inputs HTTP, secretos, tokens, red saliente, integraciones externas, datos personales.

Veredicto: APROBADO | REQUIERE CAMBIOS

---

## Resumen final

```
## PR Review completado: #<N> — <título>
- Compilación: ✅ OK / ❌ FALLA
- pr-reviewer: [APROBADO | APROBADO CON OBSERVACIONES | RECHAZADO]
- security-reviewer: [APROBADO | REQUIERE CAMBIOS | N/A]

### Acción requerida
[ninguna — listo para merge | correcciones específicas]
```
