# Auto Staging Infrastructure

## Requirements

- Terraform
- Configured AWS CLI

## Folder structure

Builder -> All Builder related infrastructure:

- TODO List

Tower -> All Tower related infrastructure:

- TODO List

## Setup

### Deploy Tower-Lambda

```bash
cd tower
make deploy
```

### Deploy Builder-Lambda

```bash
cd builder
make deploy
```

### Create / Update infrastructure

```bash
terraform apply
```

### Remove infrastructure

```bash
terraform destroy
```