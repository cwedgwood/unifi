
default: container

container:
	docker build -t unifi .
	docker images unifi

runtest: container
	docker run -d --name unifi \
		--net=host \
		-ti \
		-v /tmp/unifi-data/:/var/lib/unifi/ \
		-v /tmp/unifi-logs:/var/log/unifi/ \
		unifi
	sleep 15 # let it do something for a bit
	docker logs -t unifi
	@echo
	@echo stopping controller...
	@echo
	docker exec -ti unifi /bin/bash /stop.sh
	docker logs -t -f unifi
	docker rm unifi

clean:
	rm -f *~

.PHONY:
	default container runtest clean
