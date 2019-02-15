deploy:
	cd ~/go/src/github.com/auto-staging/builder && make build
	terraform apply --auto-approve  --var-file=../vars.tfvars