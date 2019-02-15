deploy:
	cd ~/go/src/github.com/auto-staging/tower && make build
	terraform apply --auto-approve  --var-file=../vars.tfvars