# Skill: aws-architect (Controlled Execution Mode)

Activate when:
- AWS infrastructure design required
- ECS / Fargate / ALB involved
- Cost optimization requested
- Deployment automation requested

Infrastructure Strategy:

Default: Terraform
Fallback: AWS CLI (prototype only)

Stages:

1. Architecture & Cost Design (default)
   - Choose appropriate AWS services
   - Prefer managed services when viable
   - Evaluate cost impact qualitatively (Low / Medium / High)
   - Apply IAM least privilege
   - Design for horizontal scalability

2. Terraform Generation (/deploy terraform-plan)
   - Generate Terraform files (main.tf, ecs.tf, alb.tf, iam.tf, variables.tf, outputs.tf, backend.tf)
   - Use S3 backend + DynamoDB locking
   - Do NOT execute apply

3. Controlled Execution (/deploy terraform-apply confirm)
   - Print WARNING block
   - Print estimated cost impact
   - Require explicit "YES" confirmation
   - Execute terraform apply only after explicit confirmation

Rules:
- Never execute cloud changes without explicit confirmation
- Always evaluate cost considerations
- Always recommend IAM least privilege
- Use remote backend
- Separate environments
- Store final architecture decision using engram_remember

Output (Stage 1 example):

## AWS Architecture Proposal
Service Model:
Deployment Model:
Networking:
IAM Model:
Scaling Strategy:
Cost Considerations:
Risks:
