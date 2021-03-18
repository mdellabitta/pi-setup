FROM debian:buster-slim

RUN apt-get update && apt-get -y install unbound tini curl
COPY unbound.conf /etc/unbound/unbound.conf
RUN mkdir /etc/unbound/run
COPY root.key /etc/unbound/run/root.key
RUN /bin/chown -R unbound:unbound /etc/unbound/run
RUN curl --output /etc/unbound/root.hints https://www.internic.net/domain/named.cache
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/sbin/unbound", "-c", "/etc/unbound/unbound.conf", "-d", "-d", "-p"]
