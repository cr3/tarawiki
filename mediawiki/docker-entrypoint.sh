#!/bin/sh
set -e

/usr/sbin/a2enmod ssl

sed "s|\${SERVER_HOSTNAME}|${SERVER_HOSTNAME}|" < /etc/apache2/sites-available/000-default.template > /etc/apache2/sites-available/000-default.conf

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	  set -- apache2-foreground "$@"
fi

exec "$@"
