deploy:
	cd go-scheduler && \
	go build -o ./bin/auto-staging-scheduler -v && \
	cd .. && \
	terraform apply --auto-approve