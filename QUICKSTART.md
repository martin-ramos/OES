# OES — Quickstart

Guía completa para instalar OES en una máquina nueva y comenzar a usar los agentes.

---

## Prerrequisitos

Verificar que estén instalados:

```bash
# Claude Code CLI
claude --version

# GitHub CLI (necesario para /review-pr)
gh --version

# Git
git --version
```

Para instalar Claude Code si no está:
```bash
npm install -g @anthropic-ai/claude-code
```

Para instalar GitHub CLI si no está:
```bash
# Ubuntu/Debian
sudo apt install gh

# macOS
brew install gh

# Autenticar
gh auth login
```

---

## 1. Clonar el repositorio OES

```bash
git clone https://github.com/martin-ramos/OES.git ~/OES
```

---

## 2. Configurar Claude Code

### Opción A — Global (recomendada, disponible en todos los proyectos)

```bash
# Copiar comandos al directorio global de Claude Code
cp -r ~/OES/.claude/commands/* ~/.claude/commands/

# Copiar agentes al directorio global de Claude Code
cp -r ~/OES/.claude/agents/* ~/.claude/agents/
```

Verificar:
```bash
ls ~/.claude/commands/
# debe incluir: review-pr.md, work.md, feature.md, etc.

ls ~/.claude/agents/
# debe incluir: pr-reviewer.md
```

### Opción B — Por proyecto (copiar al repo)

```bash
cd /tu/proyecto
cp -r ~/OES/.claude .
```

---

## 3. Configurar OpenCode

```bash
cd /tu/proyecto
cp -r ~/OES/.opencode .
```

---

## 4. Configurar Engram (obligatorio)

Engram es el sistema de memoria persistente entre sesiones. OES lo requiere.

### Instalar el servidor MCP de Engram

```bash
npm install -g @engramhq/engram
```

### Conectar Engram a Claude Code

Editar `~/.claude/settings.json` y agregar el servidor MCP:

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

Verificar que el servidor responde:
```bash
claude mcp list
# debe mostrar: engram
```

### Verificar conexión

Iniciar Claude Code en cualquier proyecto y ejecutar:
```
> llama engram_briefing
```
Si responde con un briefing (aunque esté vacío la primera vez), Engram está funcionando.

---

## 5. Primer uso — Verificación

En cualquier proyecto con Claude Code:

```bash
cd /tu/proyecto
claude
```

Dentro de Claude Code, probar:

```
/work hola
```

Debe responder cargando contexto de Engram y preguntando qué hacer.

```
/review-pr
```

Debe listar los PRs abiertos del repositorio actual.

---

## 6. Flujo de trabajo estándar

### Iniciar sesión (automático en /work)
El agente llama `engram_briefing` al arrancar. Carga decisiones anteriores, alertas y contexto del proyecto.

### Comandos principales

| Comando | Cuándo usarlo |
|---|---|
| `/work <descripción>` | Cualquier tarea — clasifica y delega automáticamente |
| `/feature <descripción>` | Nueva funcionalidad |
| `/bugfix <descripción>` | Corrección de bug |
| `/refactor <descripción>` | Refactor sin cambio de comportamiento |
| `/review` | Revisar cambios actuales (diff) |
| `/review-pr [número]` | Revisar un Pull Request completo antes del merge |
| `/commit` | Preparar y commitear cambios |

### Cerrar sesión
Siempre terminar con:
```
> llama engram_checkpoint
```
O usar `/work` que lo hace automáticamente al finalizar.

---

## 7. Skill: pr-reviewer

El skill más importante para revisión de PRs.

**Uso:**
```
/review-pr 42          # por número de PR
/review-pr PP-498      # por nombre de branch
/review-pr             # lista PRs abiertos y pregunta cuál
```

**Qué hace:**
1. Verifica que el proyecto **compile** — si falla, emite RECHAZADO y para
2. Lee los **commits** del PR y evalúa sus mensajes
3. Lee el **diff completo** y aplica el checklist
4. Detecta: malas prácticas, falta de patrones, código ilegible, archivos fuera de scope
5. Emite veredicto: **APROBADO** / **APROBADO CON OBSERVACIONES** / **RECHAZADO**

**Restricción:** un PR a la vez.

---

## 8. Actualizar OES en el futuro

Para traer nuevas versiones:

```bash
cd ~/OES
git pull origin main

# Reinstalar en global
cp -r ~/OES/.claude/commands/* ~/.claude/commands/
cp -r ~/OES/.claude/agents/* ~/.claude/agents/
```

---

## 9. Estructura del repositorio

```
OES/
├── .claude/                    # Integración Claude Code
│   ├── CLAUDE.md               — instrucciones de integración
│   ├── agents/                 — definición de roles
│   │   └── pr-reviewer.md
│   └── commands/               — comandos /slash
│       └── review-pr.md
├── .opencode/                  # Integración OpenCode
│   ├── OES.md                  — core del sistema
│   ├── commands.md             — comandos disponibles
│   ├── modes.md                — modos de ejecución
│   ├── skills/                 — skills activables
│   │   ├── aws-architect.md
│   │   ├── pr-reviewer.md
│   │   ├── performance-analyzer.md
│   │   ├── reliability-guard.md
│   │   └── sdd-engine.md
│   └── infrastructure/         — motor de infraestructura cloud
├── ARCHITECTURE.md             — modelo de capas y flujo
├── ENGRAM.md                   — integración Engram (memoria persistente)
├── MANIFESTO.md                — filosofía OES
├── QUICKSTART.md               — esta guía
├── README.md                   — overview del sistema
└── VERSION                     — versión actual
```

---

## Troubleshooting

**`/review-pr` no encuentra PRs:**
```bash
gh auth status   # verificar autenticación
gh pr list       # verificar que hay PRs abiertos
```

**Engram no responde:**
```bash
claude mcp list                    # verificar que aparece
claude mcp restart engram          # reiniciar el servidor
```

**Comando `/review-pr` no disponible:**
```bash
ls ~/.claude/commands/review-pr.md   # verificar que existe
# si no existe:
cp ~/OES/.claude/commands/review-pr.md ~/.claude/commands/
```

**El proyecto no compila y quiero hacer review igual:**
El pr-reviewer emitirá RECHAZADO automático. Corregir el error de compilación primero. Este comportamiento es intencional.
