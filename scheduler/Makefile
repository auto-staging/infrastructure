deploy:
	cd ~/go/src/github.com/auto-staging/scheduler && make build
	terraform apply --auto-approve  --var-file=../vars.tfvars