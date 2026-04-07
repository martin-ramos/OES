---
description: Generar tests para código existente o nuevo. Invoca test-engineer para escribir tests JUnit 5 + MockK en src/test/kotlin.
---

Tipo de tarea: **GENERACIÓN DE TESTS**

Qué testear: $ARGUMENTS

---

## test-engineer

Invoca el agente `test-engineer` para escribir los tests indicados.

### Contexto a proveer al test-engineer

Si $ARGUMENTS especifica:
- **Un servicio** → unit tests con MockK para el service indicado
- **Un controller** → tests con @WebMvcTest
- **Un repositorio con @Query custom** → tests con @DataJpaTest
- **Un comportamiento específico** → tests focused en ese comportamiento
- **Todo el código nuevo** → tests para todos los componentes nuevos sin tests

### El test-engineer debe

1. Leer el código del componente a testear antes de escribir tests
2. Identificar qué comportamientos son importantes (no solo qué líneas existen)
3. Escribir tests en `src/test/kotlin/com/appswoopa/` espejando la estructura de `src/main`
4. Verificar que compilan y pasan: `./gradlew test`

### Prioridad de cobertura
1. Happy path del comportamiento principal
2. Caso de error más probable (excepción de BD, recurso no encontrado, validación fallida)
3. Casos de borde (lista vacía, null donde no se espera, concurrencia si aplica)

---

## Resumen

```
## Tests generados: [componente]

### Archivos creados
- `src/test/.../ClaseTest.kt` — N tests

### Comportamientos cubiertos
[lista]

### Validación
- ./gradlew test: [OK/FAIL - N tests pasando]
```
