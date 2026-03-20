# OES Architecture

## Layered Model

OES operates in layers:

1. Core Principles (OES.md)
2. Active Mode (standard / performance-strict / high-reliability)
3. Optional Skills (SDD, Performance, Reliability)
4. Commands (/work, /feature, etc.)
5. Mandatory Review FINAL
6. Quality Score (EQI)

## Execution Flow

User Command
    ↓
Classification (visible)
    ↓
Skill Activation (if required)
    ↓
Pipeline Execution
    ↓
Review FINAL (explicit)
    ↓
Quality Score

## Design Goals

- Minimize token overhead
- Preserve engineering rigor
- Avoid unnecessary abstraction
- Be portable across stacks
