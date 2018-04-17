A Minimalist (Opinionated) Unifi Controller Container
=====================================================

There are (many) other Unifi® Controller containers, you might want
those.  This was created as a local migration strategy without looking
too much at the alternatives.

Here we have:

 * Debian (stretch-slim) + Unifi Controller
 * data (config & db) and logs
 * entrypoint start and stop scripts

## Using the Container ##

You'll want to provide two volumes (directories) when running the
container, one for logs and the other for data.  These should be
persisted across upgrades and backed up.  The container itself does
not need to be backed up.

Most of the time it will be easier to run this in host networking
mode.

### Starting ###

You'll probably want a start script to start the controller.  This
avoids the cumbersome command line and allows you to tweak things.

    #!/bin/sh

    docker run --net=host --name=unifi -d --restart unless-stopped \
           -v /var/lib/unifi/:/var/lib/unifi/ \
           -v /var/log/unifi/:/var/log/unifi/ \
           cwedgwood/unifi

### Stopping ###

    docker exec unifi /stop.sh

### Upgrading ###

To upgrade it should be as simple as stopping one version of the
container and starting a newer version.  Unifi does *not* allow
downgrades - backups are useful.

Assuming you've named your container `unifi` then:

Stop `docker exec unifi /stop.sh`

Cleanup `docker rm unifi`

Restart - [see above](#starting)
