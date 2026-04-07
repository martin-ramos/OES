# Engram — Memoria Persistente entre Sesiones

Engram es el sistema de memoria de OES. Permite que los agentes recuerden decisiones, convenciones y contexto entre sesiones distintas, en cualquier máquina.

---

## Instalación

```bash
npm install -g @engramhq/engram
```

Agregar a `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "engram": {
      "command": "engram",
      "args": ["--mcp"]
    }
  }
}
```

Verificar:
```bash
claude mcp list
# debe mostrar: engram
```

---

## Cuándo llamar a Engram

### Al inicio de sesión — `engram_briefing`

**Siempre**, antes de cualquier acción. Carga:
- Decisiones arquitectónicas previas
- Convenciones confirmadas del proyecto
- Alertas y pendientes de sesiones anteriores
- Contexto activo del proyecto

```
engram_briefing
```

### Al tomar decisiones — `engram_remember`

Llamar **inmediatamente** (no acumular) cuando se aprende o decide algo durable:

```
engram_remember
```

**Guardar:**
- Decisiones de arquitectura ("usamos SavedPackage en lugar de Travel.state=SAVED porque...")
- Convenciones del proyecto ("los commits no llevan Co-Authored-By")
- Patrones confirmados ("capas: resource → service → repository")
- Gotchas críticos ("ddl-auto: update no funciona con NOT NULL en tablas con datos")
- Preferencias del usuario ("no usar Co-Authored-By en commits")

**No guardar:**
- Código o diffs
- Listas de issues de review
- Estado efímero de la sesión actual
- Razonamiento intermedio

### Durante reviews — `engram_remember` selectivo

El `pr-reviewer` llama `engram_remember` solo si detecta:
- Un patrón de mala práctica recurrente en el proyecto
- Una convención del proyecto que se confirma a través del PR
- Una decisión arquitectónica validada en el review

### Al cerrar sesión — `engram_checkpoint`

**Siempre** antes de terminar. Resume qué se hizo, decisiones tomadas y estado actual.

```
engram_checkpoint
```

---

## Consultar memoria

| Función | Cuándo usar |
|---|---|
| `engram_briefing` | Inicio de sesión — resumen estructurado |
| `engram_ask` | Pregunta concreta — respuesta sintetizada |
| `engram_recall` | Análisis propio — objetos raw |
| `engram_alerts` | Chequeo rápido de alertas independiente |

---

## Qué NO recordar

- Código fuente o diffs
- Listas de tareas completadas (eso va en commits)
- Estado de PR específico (eso está en GitHub)
- Razonamiento paso a paso de una sesión
- Información redundante con el código o git log

---

## Portabilidad

Engram sincroniza la memoria entre máquinas a través de su vault en la nube. Al instalar Engram en una nueva máquina y autenticarse con la misma cuenta, toda la memoria previa está disponible inmediatamente.

Para conectar una nueva máquina:
```bash
npm install -g @engramhq/engram
engram login    # usar la misma cuenta
```

Una vez autenticado, `engram_briefing` en la nueva máquina trae todo el contexto previo.
