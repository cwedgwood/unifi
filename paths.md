file paths
==========

/usr/lib/unify/unifi-start.sh						Script used to start the controller
/entrypoint.sh -> /usr/lib/unify/unifi-start.sh		symlink to startup script

/var/log/unifi
--------------

Unifi logs

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
