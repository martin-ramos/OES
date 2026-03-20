# Skill: aws-architect (Controlled Execution Mode)

Activate when:
- AWS infrastructure design required
- ECS / Fargate / ALB involved
- Cost optimization requested
- Deployment automation requested

Stages:

1. Architecture & Cost Design (default)
   - Choose appropriate AWS services
   - Prefer managed services when viable
   - Evaluate cost impact qualitatively (Low / Medium / High)
   - Apply IAM least privilege
   - Design for horizontal scalability

2. Deployment Plan Generation (/deploy plan)
   - Generate AWS CLI commands
   - Generate ECS task definition JSON
   - Generate IAM policy templates
   - Generate networking outline (VPC, subnets, security groups)
   - Do NOT execute

3. Controlled Execution (/deploy confirm)
   - Print WARNING block
   - Print estimated cost impact
   - Require explicit "YES" confirmation
   - Execute only after explicit confirmation

Rules:
- Never execute cloud changes without explicit confirmation
- Always evaluate cost considerations
- Always recommend IAM least privilege
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
