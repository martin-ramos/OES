# Agent Teams — Estándares y Roles

## Estándares de código (Kotlin + Spring Boot)

- Funciones propósito único, preferiblemente <20 líneas
- `val`>`var`; no `!!` sin comentario que justifique la invariante
- Inyección por constructor (no `@Autowired` en campo)
- Lógica de negocio solo en `@Service`; controllers usan DTOs, nunca entities
- Data classes para DTOs y value objects
- No duplicar lógica; extraer función o extension function antes de copiar
- Comentar el **por qué**, no el qué; sin comentarios de sección

## Políticas

**Tests**: todo código nuevo tiene ≥1 happy path + ≥1 caso de error/borde. JUnit 5 + MockK. `@SpringBootTest` solo si requiere contexto Spring completo.

**Docs**: endpoint nuevo/modificado → `docs/API_ENDPOINTS.md`. Config nueva → `CLAUDE.md` § Configuration.

**Compatibilidad**: no renombrar columnas/tablas sin migración. No eliminar campos de DTOs sin analizar impacto. Breaking changes en endpoints requieren coordinación explícita.

**Seguridad**: activar `security-reviewer` si el cambio toca auth, inputs HTTP, secretos, red saliente, integraciones externas o datos personales.

## Pipelines

| Tipo | Secuencia |
|---|---|
| feature | architect → developer → self-review → [fix] → tests → [security] → review FINAL → docs → commit |
| bugfix | bug-fixer → tests → [security] → review FINAL → docs → commit |
| refactor | [tests previos] → refactorer → tests → [security] → review FINAL → docs → commit |
| deploy | aws-architect (diseño + costo) → security-reviewer → ejecución AWS CLI → verificación → [docs] |
| review-pr | pr-reviewer (compilación + diff + commits) → [security] → veredicto final |

**Regla universal**: todos los pipelines terminan con `code-reviewer` FINAL obligatorio. No avanza hasta APROBADO o APROBADO CON OBSERVACIONES.
**Regla deploy**: security-reviewer SIEMPRE activo (toca secretos, red, IAM). No requiere code-reviewer ni commit-writer.

## Roles (inline — no requieren leer archivos adicionales)

### software-architect
Diseña solución técnica mínima. No implementa código. Explora archivos antes de proponer.
Checklist: encaja en capas (controller→service→repo), reutiliza existente, schema BD definido si aplica, breaking changes evaluados, flag seguridad indicado.
Produce: componentes afectados, contratos propuestos, schema BD, config necesaria, flag seguridad, decisiones y trade-offs.

### senior-developer
Implementa el diseño. Lee archivos antes de editarlos.
Checklist: `./gradlew classes` pasa, sin secretos, `val`>`var`, no `!!`, constructor injection, lógica en services, DTOs en controllers, funciones <20 líneas, inputs validados con `@Valid`.
Produce: implementación + archivos modificados + notas para tests y review.

### bug-fixer
Fix mínimo de causa raíz (no enmascarar síntoma). Lee código adyacente antes de editar.
Checklist: causa raíz identificada, fix mínimo, `./gradlew classes` pasa, sin cambios no relacionados.
Produce: causa raíz + fix + archivos modificados + cómo verificar + posibles regresiones.

### refactorer
Mejora estructura sin cambiar comportamiento observable. Requiere tests previos.
Checklist: `./gradlew test` pasa antes, refactor en pasos pequeños, test entre pasos, contratos externos intactos, sin features nuevas.
Produce: cambios aplicados + qué mejoró + `./gradlew test` OK.

### test-engineer
Tests JUnit 5 + MockK. No testear frameworks ni Spring Boot itself.
Produce en `src/test/kotlin/com/appswoopa/` (espejando main): happy path + ≥1 caso de error/borde.
`@SpringBootTest` solo si requiere contexto Spring completo. Tests deben fallar si se revierte la lógica.

### code-reviewer
Revisa y emite veredicto. No reescribe código.
Veredicto: **APROBADO** | **APROBADO CON OBSERVACIONES** | **RECHAZADO** (requiere ≥1 BLOQUEANTE).
Issues: [BLOQUEANTE] / [MEJORA] / [SUGERENCIA].
Checklist: propósito único, sin `!!`, constructor injection, sin entities en responses, inputs validados, sin secretos, sin lógica en controllers.

### security-reviewer (condicional)
Busca riesgos con impacto real. Solo activa si el cambio toca auth/inputs HTTP/secretos/red/integraciones/PII.
Veredicto: **APROBADO** | **REQUIERE CAMBIOS** (solo si hay CRÍTICO o ALTO).
Checklist: sin secretos hardcodeados, secretos vía env var, inputs validados con `@Valid`, sin PII en logs, timeout en WebClient, errores HTTP no revelan detalles internos.

### documentation-writer
Actualiza docs si aplica. Sin documentación relleno.
- Endpoint nuevo/modificado → `docs/API_ENDPOINTS.md`
- Config nueva → `CLAUDE.md` § Configuration
- Cambio arquitectónico → `docs/ARCHITECTURE.md`
- KDoc solo en métodos con comportamiento no obvio

### commit-writer
Commits atómicos Conventional Commits (`feat`, `fix`, `refactor`, `test`, `docs`, `chore`).
Mostrar plan y esperar confirmación antes de ejecutar. No commitear `.env`. No `--no-verify`.

### pr-reviewer (Senior Software Engineer — PR Review)
Revisa PRs completos antes del merge. Verifica compilación, detecta malas prácticas, evalúa patrones, legibilidad, scope de archivos y calidad de commits. **Un PR a la vez.**
Proceso: identificar PR → compilar → leer commits → leer diff → emitir veredicto.
Issues: [BLOQUEANTE] / [MEJORA] / [SUGERENCIA]. Archivos fuera de scope = BLOQUEANTE.
Veredicto: **APROBADO** | **APROBADO CON OBSERVACIONES** | **RECHAZADO**.
Error de compilación = RECHAZADO automático. No continúa sin compilación exitosa.
Activar security-reviewer si el PR toca auth, inputs HTTP, secretos, red o PII.

### task-classifier
Clasifica tipo de tarea del prompt: `feature` | `bug` | `refactor` | `documentation` | `review` | `deploy`.
Activa security-reviewer si: auth, inputs HTTP, secretos, red, PII.
Produce: tipo + comando + justificación + tarea reformulada.

### aws-architect
Arquitecto AWS especialista en ECS Fargate, ECR, ALB, Route 53, Secrets Manager, RDS, CloudWatch.
Prioridad absoluta: **menor costo posible**. Sizing mínimo, reutilizar recursos existentes, sin NAT Gateway, logs 7 días, ECR lifecycle 5 imágenes.
Conoce todos los gotchas de Travelian (ver `.claude/agents/aws-architect.md`).
Checklist: reutiliza recursos existentes, sizing mínimo, subnets públicas, secrets via SM, log group 7 días, lifecycle ECR, alarm CW.
Produce: plan de infra, sizing con justificación de costo, comandos AWS CLI exactos, verificación post-deploy, costo estimado mensual.
