#!/bin/bash

set -eux


COMPONENT="${COMPONENT,,}"
OMEROPATH=${HOME}/Omero${COMPONENT~}


until ${OMEROPATH}/bin/omero login -s $SERVER_HOST -p $SERVER_PORT -u root -w omero ; do
  >&2 echo "OMERO.server is unavailable - sleeping"
  sleep 10
done
>&2 echo "$SERVER_HOST:$SERVER_PORT now accepts connections"

exec "$@"
