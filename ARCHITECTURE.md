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

## Cloud Extension

When AWS-related tasks are detected, the `aws-architect` skill may activate.

Flow:

Architecture Proposal
    ↓
Cost Evaluation
    ↓
Terraform Generation (default)
    ↓
Terraform Plan (safe)
    ↓
Terraform Apply (explicit confirmation required)

Cloud execution is never automatic.

## Terraform Governance (v1.1.0)

Rules:
- Use S3 remote backend
- Use DynamoDB state locking
- No local state in production
- Separate environments (dev/staging/prod)
- Tag all resources
- Apply IAM least privilege
- Never hardcode credentials

## Design Goals

- Minimize token overhead
- Preserve engineering rigor
- Avoid unnecessary abstraction
- Be portable across stacks
