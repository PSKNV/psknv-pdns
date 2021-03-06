FROM alpine:3.12.1

RUN cat /etc/apk/repositories

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main' > /etc/apk/repositories; echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

ENV VERSION="4.3.1-r0" \
  PDNS_guardian=yes \
  PDNS_setuid=pdns \
  PDNS_setgid=pdns

RUN apk update

RUN apk add --no-cache \
    mariadb-client \
    pdns \
    pdns-backend-mysql \
    pdns-backend-sqlite3 \
    pdns-backend-bind \
    pdns-backend-geoip \
    py3-pip \
    python3 \
    sqlite

RUN pip3 install --no-cache-dir envtpl

COPY pdns.conf.tpl /
COPY entrypoint.sh /
COPY sqlite3.sql /

RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8081 8081/tcp

EXPOSE 5353 53/udp
EXPOSE 5353 53/tcp