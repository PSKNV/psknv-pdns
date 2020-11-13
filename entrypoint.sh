#!/bin/sh
set -e

# --help, --version
[ "$1" = "--help" ] || [ "$1" = "--version" ] && exec pdns_server $1
# treat everything except -- as exec cmd
[ "${1:0:2}" != "--" ] && exec "$@"

mkdir -p /etc/pdns/pdns.d
mkdir -p /var/run/pdns

chmod 755 -R /etc/pdns
chmod 755 -R /var/run/pdns

envtpl < /pdns.conf.tpl > /etc/pdns/pdns.conf

trap "/usr/sbin/pdns_control quit" SIGHUP SIGINT SIGTERM

cat /sqlite3.sql | sqlite3 /pdns.sqlite
/usr/sbin/pdns_server --daemon=no --guardian=no --loglevel=9 "$@" &

wait