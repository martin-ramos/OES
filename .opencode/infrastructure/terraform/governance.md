# Terraform Governance

Mandatory:
- Remote backend
- State locking
- Separate environments (dev/staging/prod)
- Resource tagging
- IAM least privilege

Never:
- Local state in production
- Hardcoded credentials
- Uncontrolled apply
