---
description: Revisión de código. Ejecuta code-reviewer sobre los archivos o cambios indicados. Agrega security-reviewer automáticamente si el código toca auth, inputs externos, secretos o red.
---

Tipo de tarea: **CODE REVIEW**

Código a revisar: $ARGUMENTS

## Qué se ejecutará

1. **code-reviewer** — sobre el código indicado
2. **security-reviewer** — si el código toca auth, inputs externos, secretos, red, integraciones o datos sensibles

Anuncia al inicio si incluyes security-reviewer y por qué.

---

## Paso 1 — code-reviewer

Invoca el agente `code-reviewer` para revisar el código indicado.

Si no se especificaron archivos concretos, revisar los cambios más recientes:
- Archivos con cambios no commiteados (`git diff`)
- O los archivos mencionados en $ARGUMENTS

El reviewer emite veredicto: APROBADO | APROBADO CON OBSERVACIONES | RECHAZADO
con lista de issues clasificados (BLOQUEANTE / MEJORA / SUGERENCIA).

---

## Paso 2 (condicional) — security-reviewer

Si el código revisado toca:
- Auth o autorización
- Inputs del usuario (HTTP body, query params, path variables, headers)
- Secretos, tokens o credenciales
- Llamadas de red salientes
- Integraciones con sistemas externos (Facebook GraphQL, Nominatim, LLM, Apify)
- Datos personales o sensibles

Invoca el agente `security-reviewer`.
El reviewer emite veredicto: APROBADO | REQUIERE CAMBIOS.

---

## Resumen

```
## Review completado: [archivo/cambio]

### Veredictos
- code-reviewer: [APROBADO | APROBADO CON OBSERVACIONES | RECHAZADO]
- security-reviewer: [APROBADO | REQUIERE CAMBIOS | N/A]

### Issues encontrados
[lista consolidada con clasificación]

### Acción requerida
[ninguna | correcciones específicas antes de merge]
```
