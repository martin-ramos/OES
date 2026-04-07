---
description: Analizar los cambios actuales y crear commits atómicos con mensajes en formato Conventional Commits. Muestra el plan antes de commitear y pide confirmación.
---

Tipo de tarea: **COMMIT**

Contexto adicional (opcional): $ARGUMENTS

---

## commit-writer

Invoca el agente `commit-writer` para analizar el estado actual del repositorio y crear commits atómicos.

El agente debe:
1. Ejecutar `git status` y `git diff` para entender todos los cambios
2. Proponer un plan de commits atómicos con sus mensajes antes de ejecutar nada
3. Esperar confirmación del usuario
4. Crear los commits en orden lógico (dependencias primero)
5. Mostrar `git log --oneline` con los commits creados al final

Si $ARGUMENTS tiene contexto (ej: "esto es parte del feature de notificaciones"), usarlo para escribir mensajes más precisos.
