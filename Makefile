
default: container

container:
	sudo docker build -t unifi .
	sudo docker images unifi

runtest: container
	sudo docker run -d --rm --name unifi \
		--net=host \
		--rm -ti \
		-v /tmp/unifi-data/:/var/lib/unifi/ \
		-v /tmp/unifi-logs:/var/log/unifi/ \
		unifi
	sleep 15 # let it do something for a bit
	sudo docker logs unifi
	sudo docker exec -ti unifi /bin/bash /stop.sh
	sudo docker logs -f unifi

clean:
	rm -f *~

.PHONY:
	default container runtest clean
