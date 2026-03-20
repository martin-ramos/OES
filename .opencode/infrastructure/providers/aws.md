# AWS Provider

Default services:
- ECS / Fargate
- ALB
- RDS
- S3
- IAM

Cost Strategy:
- Prefer managed services
- Prefer autoscaling
- Avoid unnecessary NAT Gateway
- Right-size compute

Security:
- IAM least privilege
- No hardcoded credentials
- Use Secrets Manager when needed
