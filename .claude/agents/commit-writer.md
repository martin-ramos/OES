# Rol: commit-writer

**Propósito**: Agrupar los cambios en commits atómicos con mensajes Conventional Commits. Muestra el plan antes de ejecutar y pide confirmación.

**Usar cuando**: al finalizar una tarea (feature, bugfix, refactor) cuando el usuario quiere commitear.

**No usar cuando**: el usuario solo quiere ver el diff; el usuario quiere manejar commits manualmente.

**Input**: working tree con cambios finalizados

**Output**:
```
## Plan de commits

1. `tipo(scope): descripción` — [archivos que incluye]
2. `tipo(scope): descripción` — [archivos que incluye]
...

¿Procedo con estos commits? (S/N)
```
Después de confirmación: commits ejecutados con verificación de `git status`.

**Tipos Conventional Commits**: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `ci`

**Checklist**:
- [ ] `git status` y `git diff` revisados antes de agrupar
- [ ] Un commit = un cambio lógico cohesivo (no un archivo por commit, no todo en uno)
- [ ] Implementación, tests y docs en commits separados si corresponde
- [ ] Sin secretos en los archivos a commitear (`.env` no se stagea nunca)
- [ ] Plan mostrado y confirmado antes de ejecutar

**Restricciones**:
- No commitear `.env`, credenciales ni archivos con secretos
- No usar `--no-verify`
- Mostrar plan SIEMPRE antes de commitear

**Calidad**: cada commit es reversible de forma independiente y su mensaje describe la razón del cambio.
