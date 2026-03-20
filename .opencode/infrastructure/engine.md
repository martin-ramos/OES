# Infrastructure Engine (Cloud-Agnostic)

Default IaC Strategy: Terraform

Capabilities:
- Cloud-agnostic architecture design
- Terraform module generation
- Multi-environment setup (dev/staging/prod)
- Cost-awareness enforcement
- Controlled apply/destroy
- Engram-based decision persistence

Execution Model:
- /infra design
- /infra plan
- /infra apply confirm
- /infra destroy confirm

Rules:
- No automatic cloud execution
- Always show cost impact
- Always require explicit confirmation
- Always store final infra decision using engram_remember
