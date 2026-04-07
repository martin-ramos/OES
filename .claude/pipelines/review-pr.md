# Pipeline: review-pr

**Modelo**: Claude ejecuta cada fase inline. NO usar Agent tool para fases del pipeline.
**Referencia de roles completos**: `.claude/teams/AGENTS.md`
**Restricción**: revisar **un PR a la vez**. Si se pasan múltiples PRs, procesar el primero y avisar.

---

## Fase 0 — Identificación

Obtener número o branch del PR desde los argumentos.
Si no se especifica, listar PRs abiertos:
```bash
gh pr list --limit 10
```
Preguntar cuál revisar si hay más de uno.

Anuncia: "Revisando PR #N: <título> (<origen> → <destino>)"

¿El PR toca auth / inputs HTTP / secretos / red / PII? → activar security-reviewer en Fase 3.

---

## Fase 1 — pr-reviewer

Ejecuta el rol `pr-reviewer` completo:
1. Identificar PR y mostrar metadata
2. Verificar compilación (`./mvnw compile -q` o `./gradlew classes`)
3. Leer commits y evaluar mensajes
4. Leer diff completo y aplicar checklist

**Si no compila**: emitir RECHAZADO inmediato. Pipeline se detiene aquí.
**Si compila**: continuar con el análisis completo.

El reviewer emite veredicto: **APROBADO** | **APROBADO CON OBSERVACIONES** | **RECHAZADO**

---

## Fase 2 (condicional) — security-reviewer

*Solo si el PR toca: auth, inputs HTTP, secretos, tokens, red saliente, integraciones externas, datos personales.*

Aplicar checklist de seguridad sobre el diff del PR.
Veredicto: APROBADO | REQUIERE CAMBIOS

Si REQUIERE CAMBIOS: listar correcciones necesarias antes del merge.

---

## Resumen final

```
## PR Review completado: #<número> — <título>

### Veredictos
- Compilación: ✅ OK / ❌ FALLA
- pr-reviewer: [APROBADO | APROBADO CON OBSERVACIONES | RECHAZADO]
- security-reviewer: [APROBADO | REQUIERE CAMBIOS | N/A]

### Issues que bloquean el merge
[lista de BLOQUEANTEs, o "ninguno"]

### Acción requerida
[ninguna — listo para merge | correcciones específicas antes de merge]
```
