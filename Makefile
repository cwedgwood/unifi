
TAG := testi-unifi
TESTC := testc-unifi

default: container

runtest-unifi-data runtest-unifi-logs:
	docker run -ti --rm \
		-v $(PWD)/runtest-unifi-data:/var/lib/unifi/ \
		-v $(PWD)/runtest-unifi-logs:/var/log/unifi/ \
		cwedgwood/bldr:0.03 chown 42002:42002 /var/lib/unifi/ /var/log/unifi/

container: runtest-unifi-data runtest-unifi-logs
	docker build -t $(TAG) .
	docker images $(TAG)

runtest: container
	docker run -d --name $(TESTC) \
		-ti \
		-v $(PWD)/runtest-unifi-data:/var/lib/unifi/ \
		-v $(PWD)/runtest-unifi-logs:/var/log/unifi/ \
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
	sudo rm -rf runtest-unifi-data runtest-unifi-logs

.PHONY:
	default container runtest clean
