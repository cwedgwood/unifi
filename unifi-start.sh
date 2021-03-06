#!/bin/bash
#
# start unifi in a docker container

#set -ex
set -e

# check we have the requisite volumes mounted
verr=0
for v in /var/log/unifi/ /var/lib/unifi/ ; do
    if [ -e "$v/not-supplied" ] ; then
	echo "ERROR: Volume $v not supplied"
	verr=1
    fi
done
[ "${verr}" -ne 0 ] && ( echo "ERROR: refusing to start..." ; exit 2 )

echo "INFO: Starting container, logs are in  /var/log/unifi/"

cd /usr/lib/unifi
exec java -XX:-UsePerfData -Djava.security.egd=file:/dev/urandom -jar lib/ace.jar start
