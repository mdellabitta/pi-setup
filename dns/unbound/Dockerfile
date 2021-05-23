FROM debian:buster-slim
RUN apt-get update && apt-get -y install unbound tini curl
COPY unbound.conf /etc/unbound/unbound.conf
RUN mkdir /etc/unbound/run
RUN cp /usr/share/dns/root.key /etc/unbound/run/root.key
RUN cp /usr/share/dns/root.hints /etc/unbound/root.hints
RUN /bin/chown -R unbound:unbound /etc/unbound/run
RUN unbound-checkconf /etc/unbound/unbound.conf
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/sbin/unbound", "-c", "/etc/unbound/unbound.conf", "-d", "-d", "-p"]
