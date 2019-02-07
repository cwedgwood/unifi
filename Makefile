
TAG := testi-unifi
TESTC := testc-unifi

default: runtest

runtest-unifi-data runtest-unifi-logs:
	docker run -ti --rm \
		-v $(PWD)/runtest-unifi-data:/var/lib/unifi/ \
		-v $(PWD)/runtest-unifi-logs:/var/log/unifi/ \
		cwedgwood/bldr:0.04 chown 42002:42002 /var/lib/unifi/ /var/log/unifi/

container: runtest-unifi-data runtest-unifi-logs
	docker build -t $(TAG) .
	docker images $(TAG)

runtest: container
	-docker rm -f $(TESTC) || true
	docker run -d --name $(TESTC) \
		-ti \
		-v $(PWD)/runtest-unifi-data:/var/lib/unifi/ \
		-v $(PWD)/runtest-unifi-logs:/var/log/unifi/ \
		$(TAG)
	sleep 2 # enough time to start and create logs?
	echo "IP:"
	docker inspect -f "{{ .NetworkSettings.IPAddress }}" testc-unifi
	echo "Sleeping for a bit ... showing logs:"
	tail -f $(PWD)/runtest-unifi-logs/* &
	sleep 60 # let it do something for a bit
	@echo
	@echo stopping controller...
	@echo
	docker exec -ti $(TESTC) /bin/bash /stop.sh
	docker logs -t -f $(TESTC)
	-docker rm -f $(TESTC) || true

clean:
	rm -f *~
	-docker rm -f $(TESTC) || true
	sudo rm -rf runtest-unifi-data runtest-unifi-logs

realclean: clean
	docker rmi $(TAG)

.PHONY:
	default container runtest clean
