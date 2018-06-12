
TAG := testi-unifi
TESTC := testc-unifi

default: container

container:
	docker build -t $(TAG) .
	docker images $(TAG)

runtest: container
	docker run -d --name $(TESTC) \
		-ti \
		-v runtest-unifi-data:/var/lib/unifi/ \
		-v runtest-unifi-logs:/var/log/unifi/ \
		$(TAG)
	sleep 15 # let it do something for a bit
	docker logs -t $(TESTC)
	@echo
	@echo stopping controller...
	@echo
	docker exec -ti $(TESTC) /bin/bash /stop.sh
	docker logs -t -f $(TESTC)
	docker rm $(TESTC)

clean:
	rm -f *~

.PHONY:
	default container runtest clean
