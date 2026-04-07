---
description: Documentar un feature, endpoint o componente. Invoca documentation-writer para actualizar docs/ y CLAUDE.md según lo que cambió.
---

Tipo de tarea: **DOCUMENTACIÓN**

Qué documentar: $ARGUMENTS

---

## documentation-writer

Invoca el agente `documentation-writer` para documentar lo indicado.

El writer debe:
1. Leer el código fuente relevante para entender el comportamiento real (no inventar)
2. Identificar qué documentación existe hoy en `docs/` que corresponde actualizar
3. Producir o actualizar solo lo que falta o está desactualizado

### Prioridad de documentación según el tipo de cambio

| Si se indica... | Actualizar |
|---|---|
| Endpoint REST | `docs/API_ENDPOINTS.md` |
| Variable de entorno nueva | `CLAUDE.md` sección Configuration |
| Flujo de tareas/scheduler | `docs/FLUJO_TAREAS.md` |
| Flujo de búsqueda/scraping | `docs/FLUJO_BUSQUEDA_END_TO_END.md` |
| Decisión arquitectónica | `docs/ARCHITECTURE.md` |
| Configuración de Facebook GraphQL | `docs/FACEBOOK_GRAPHQL_API.md` |

### Estilo
- Conciso y escaneable (tablas, bloques de código JSON, secciones cortas)
- Sin documentación relleno
- Ejemplos de request/response reales (extraídos del código, no inventados)

---

## Resumen

```
## Documentación actualizada: [tema]

### Archivos modificados
- `docs/Archivo.md` — sección actualizada

### Documentación obsoleta eliminada (si aplica)
[sección o líneas removidas]
```
