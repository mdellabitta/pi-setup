FROM debian:buster-slim

RUN apt-get update && apt-get -y install unbound tini 
COPY unbound.conf /etc/unbound/unbound.conf

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/sbin/unbound", "-c", "/etc/unbound/unbound.conf", "-d", "-d"]
