# cloud_resume_infra

> Production-grade AWS resume site — S3, CloudFront, Lambda, DynamoDB, Terraform, GitHub Actions CI/CD

![CI](https://github.com/traliach/cloud_resume_infra/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/github/license/traliach/cloud_resume_infra)
![Tag](https://img.shields.io/github/v/tag/traliach/cloud_resume_infra)

## Architecture

<!-- Add architecture diagram here -->
```
[diagram coming soon]
```

## Prerequisites

- [Terraform](https://terraform.io) >= 1.5
- [AWS CLI](https://aws.amazon.com/cli/) configured
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (if K8s)

## Quick start

```bash
git clone https://github.com/traliach/cloud_resume_infra.git
cd cloud_resume_infra
cp terraform.tfvars.example terraform.tfvars
# fill in your values
terraform init
terraform plan
terraform apply
```

## Structure

```
cloud_resume_infra/
├── infra/          # Terraform modules
├── .github/        # CI/CD workflows
├── docs/           # Architecture diagrams and runbooks
├── CHANGELOG.md
└── README.md
```

## Deployment

See [CONTRIBUTING.md](./CONTRIBUTING.md) for branch and PR workflow.

## License

[MIT](./LICENSE) © 2026 Achille Traore | [achille.tech](https://achille.tech)
