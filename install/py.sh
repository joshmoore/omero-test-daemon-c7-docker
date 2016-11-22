#!/bin/bash

set -eux


COMPONENT="${COMPONENT,,}"
OMEROPATH=${OMEROPATH:-"${HOME}/OMERO.${COMPONENT}"}

if [ "$SKIP_UPGRADE_CHECK" = true ]; then
    ${OMEROPATH}/bin/omero config set omero.upgrades.url ""
fi

until ${OMEROPATH}/bin/omero login -s $SERVER_HOST -p $SERVER_PORT -u root -w omero ; do
  >&2 echo "OMERO.server is unavailable - sleeping"
  sleep 10
done
>&2 echo "$SERVER_HOST:$SERVER_PORT now accepts connections"

exec "$@"
