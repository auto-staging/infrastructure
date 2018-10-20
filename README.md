# Auto Staging Tower Infrastructure

## Requirements

- Terraform
- Configured AWS CLI

## Setup

### Build code for Lambda

```bash
cd go-src
go build -o tower
```

### Configure infrastructure

```bash
terraform apply
```

### Remove infrastructure

```bash
terraform destroy
```