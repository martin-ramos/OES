# Pipeline: deploy

**Propósito**: Diseñar y ejecutar deploys a AWS producción (ECS Fargate). Cubre nuevo microservicio, redeploy de imagen, y cambios de infraestructura.
**Modelo**: Claude ejecuta cada fase inline. NO usar Agent tool para fases del pipeline.
**Referencia de roles completos**: `.claude/teams/AGENTS.md` + `.claude/agents/aws-architect.md`

---

## Fase 0 — Evaluación inicial

Identificar el tipo de operación:
- **A) Nuevo microservicio**: requiere crear ECR, secret, target group, regla ALB, task def, servicio ECS, DNS, alarm
- **B) Redeploy (actualizar imagen)**: build, push, `update-service --force-new-deployment`
- **C) Cambio de infra**: modificar task definition, secrets, variables de entorno, sizing

Anuncia el tipo detectado y el plan completo que se ejecutará.

> Security-reviewer SIEMPRE activo en deploys: toca secretos, red, IAM.

---

## Fase 1 — aws-architect (diseño)

Adoptar el rol aws-architect. Antes de ejecutar cualquier comando:

1. Verificar existencia de recursos reutilizables (no crear lo que ya existe)
2. Proponer sizing mínimo (cpu=256/memory=512 por defecto)
3. Identificar gotchas aplicables al caso (ver `.claude/agents/aws-architect.md`)
4. Producir plan detallado con comandos exactos y costo estimado

**Checklist**:
- [ ] Reutiliza ALB, RDS, cluster, zona R53 existentes
- [ ] Sizing empieza en mínimo Fargate (cpu=256/memory=512)
- [ ] desired count=1 salvo justificación
- [ ] Gotchas Quarkus/ECS identificados si aplican
- [ ] Archivos JSON preparados para comandos complejos (zsh)
- [ ] Log group con retención 7 días
- [ ] ECR lifecycle policy máximo 5 imágenes

Avanza: plan claro y completo antes de ejecutar nada.

---

## Fase 2 — security-reviewer (siempre activo en deploy)

Revisar el plan de infra antes de ejecutar:
- [ ] Secrets via Secrets Manager (nunca hardcodeados en task def o env vars en plano)
- [ ] Security group mínimo — solo puertos necesarios abiertos
- [ ] No PII en variables de entorno o logs
- [ ] IAM role con least-privilege (usar `travelian-ecs-execution-role` existente)
- [ ] assignPublicIp=ENABLED implica exposición pública — confirmar que el SG lo restringe adecuadamente

Veredicto: **APROBADO** | **REQUIERE CAMBIOS** (solo si CRÍTICO/ALTO).
Si REQUIERE CAMBIOS: corregir plan y re-ejecutar esta fase.

---

## Fase 3 — Ejecución AWS CLI

Ejecutar los comandos del plan en orden. Usar `Bash` tool para cada comando.

**Orden obligatorio** (nuevo microservicio):
1. ECR repository + lifecycle policy
2. Build y push imagen
3. Secret en Secrets Manager (si aplica)
4. Base de datos (si aplica — requiere acceso)
5. CloudWatch log group (retención 7 días)
6. Target group
7. Regla ALB
8. Task definition (`file://`)
9. ECS service (`file://`)
10. DNS Route 53 (`file://`)
11. CloudWatch alarm

**Orden obligatorio** (redeploy):
1. Build y push imagen
2. `update-service --force-new-deployment`
3. `wait services-stable`

**Ante cualquier error**: detener, diagnosticar causa raíz, corregir antes de continuar. No reintentar el mismo comando sin entender el error.

---

## Fase 4 — Verificación post-deploy

```bash
# Estado del servicio
aws ecs describe-services --cluster travelian-prod --services travelian-NOMBRE \
  --region eu-central-1 \
  --query 'services[0].{running:runningCount,desired:desiredCount,status:status,events:events[0:3]}'

# Logs recientes
aws logs tail /ecs/travelian-NOMBRE --since 5m --region eu-central-1

# Health del target group
aws elbv2 describe-target-health --target-group-arn TG_ARN --region eu-central-1
```

Avanza: `runningCount == desiredCount` y target group healthy.

Si la task no levanta:
1. Ver logs con `aws logs tail`
2. Ver `stoppedReason` con `aws ecs describe-tasks`
3. Diagnosticar y corregir (gotcha de health check, imagen mala, secret mal formateado, etc.)

---

## Fase 5 — documentation-writer (condicional)

Solo si se creó un nuevo microservicio o se modificó la arquitectura.
- Actualizar `docs/ARCHITECTURE.md` con el nuevo servicio
- Actualizar `CLAUDE.md` § Configuration si hay variables de entorno nuevas
- Actualizar `docs/API_ENDPOINTS.md` si el servicio expone endpoints públicos

---

## Resumen final obligatorio

```
## Deploy completado: [nombre]
### Tipo de operación
[nuevo microservicio | redeploy | cambio de infra]
### Recursos creados/modificados
[lista de recursos AWS con ARNs o nombres]
### Sizing final
cpu=X memory=X, desired count=N
### URL de producción
https://NOMBRE.api.travelian.eu
### Costo estimado adicional
~$X/mes
### Verificación
- ECS: running=N/N ✓
- Target group: healthy ✓
- Logs: sin errores ✓
### Documentación
[actualizada | N/A]
```
