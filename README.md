# Auto Staging Infrastructure

## Requirements

- Terraform
- Configured AWS CLI

## Setup

### Checkout Lambda code repositories to $GOPATH/src/gitlab.com/auto-staging

```bash
cd $GOPATH/src/gitlab.com/auto-staging

git clone git@gitlab.com:auto-staging/scheduler.git
git clone git@gitlab.com:auto-staging/builder.git
git clone git@gitlab.com:auto-staging/tower.git
```

### Create Symlinks for Lambda go

```bash
make symlinks
```

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

### Deploy Scheduler-Lambda

```bash
cd scheduler
make deploy
```

## License and Author

Author: Jan Ritter

License: MIT