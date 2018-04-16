file paths
==========

Start/stop scripts and we as convenient symlinks:

    /usr/lib/unify/unifi-start.sh
    /usr/lib/unify/unifi-stop.sh
    /entrypoint.sh -> /usr/lib/unify/unifi-start.sh
    /stop.sh -> /usr/lib/unify/unifi-stop.sh

/var/log/unifi
--------------

Logs for MongoDB and the Unifi Controller.

/var/lib/unifi
--------------

Unifi configuration and state, relevant paths inside of this:

    db/

The MongoDB database.

    system.properties

Java settings and magic.

    keystore

Java SSL certs, keys and magic.

A (new) SSL cert can be installed using:

    # PRIVKEY=path/to/private-key.pem
	# CERT=path/to/issued-cert.pem

    openssl pkcs12 -export \
		-inkey "${PRIVKEY}" \
		-in "${CERT}" \
		-out /tmp/unifi.p12 \
		-name ubnt -password pass:temppass

    keytool -importkeystore -deststorepass aircontrolenterprise \
	    -destkeypass aircontrolenterprise \
		-destkeystore /var/lib/unifi/keystore \
		-srckeystore /tmp/unifi.p12 \
		-srcstoretype PKCS12 \
		-srcstorepass temppass -alias ubnt -noprompt

The controller doesn't notice the `/var/lib/unifi/keystore` file
update, you will need to restart the container.
