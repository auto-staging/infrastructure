deploy:
	cd go-builder && \
	go build -o ./bin/auto-staging-builder -v && \
	cd .. && \
	terraform apply --auto-approve