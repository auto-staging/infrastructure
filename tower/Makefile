deploy:
	cd go-tower && \
	go build -o ./bin/auto-staging-tower -v && \
	cd .. && \
	terraform apply --auto-approve