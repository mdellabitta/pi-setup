FROM alpine:latest

RUN apk update && apk add unbound tini 
COPY unbound.conf /etc/unbound/unbound.conf

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/unbound", "-c", "/etc/unbound/unbound.conf", "-d", "-d"]
