# -*- conf -*-

FROM debian:stretch-slim

# debian:stretch-slim lacks this, needed or alternates throws errors
RUN mkdir -p /usr/share/man/man1/


# BASE SYSTEM

# *required* to make unifi happy: binutils libcap2 procps (for pgrep),
# *required*/useful (and small): wget, less
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends mongodb-server jsvc openjdk-8-jre-headless binutils libcap2 procps wget less && \
    apt-get clean && \
    find /var/lib/apt/lists/ -type f -print0 | xargs -r0 rm


# ADD UNIFI CONTROLLER

RUN cd / && \
    wget -q https://dl.ubnt.com/unifi/5.7.23-7957bc47e8/unifi_sysvinit_all.deb && \
    DEBIAN_FRONTEND=noninteractive TERM=dumb dpkg -i /unifi_sysvinit_all.deb && \
    rm /unifi_sysvinit_all.deb


# Suggested but maybe not entirely useful
EXPOSE 6789/tcp 8080/tcp 8443/tcp 8880/tcp 8843/tcp 3478/udp


# Checked by startup script to make make sure volumes are supplied
RUN touch /var/log/unifi/not-supplied /var/lib/unifi/not-supplied

COPY unifi-start.sh unifi-stop.sh /usr/lib/unifi/
RUN ln -s /usr/lib/unifi/unifi-start.sh /entrypoint.sh && \
    ln -s /usr/lib/unifi/unifi-stop.sh /stop.sh

RUN cd /usr/lib/unifi && \
        ln -s /run/unifi run && \
	ln -s /var/lib/unifi/ data && \
	ln -s /var/log/unifi logs

CMD [ "/usr/lib/unifi/unifi-start.sh" ]
