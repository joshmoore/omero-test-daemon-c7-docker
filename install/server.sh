#!/bin/bash

set -eux


COMPONENT="${COMPONENT,,}"
OMEROPATH=${HOME}/Omero${COMPONENT~}


echo "Waiting on Postgres..."
until psql -h $OMERO_DB_HOST -p $OMERO_DB_PORT -U $OMERO_DB_USER -c '\l'; do
  >&2 echo "$OMERO_DB_HOST is unavailable - sleeping"
  sleep 5
done
>&2 echo "$OMERO_DB_HOST now accepts connections, creating database $OMERO_DB_NAME..."


echo "Loading config..."
${OMEROPATH}/bin/omero config set omero.db.host $OMERO_DB_HOST
${OMEROPATH}/bin/omero config set omero.db.port $OMERO_DB_PORT
${OMEROPATH}/bin/omero config set omero.db.user $OMERO_DB_USER
${OMEROPATH}/bin/omero config set omero.db.name $OMERO_DB_NAME
if [ "$SKIP_UPGRADE_CHECK" = true ]; then
    ${OMEROPATH}/bin/omero config set omero.upgrades.url ""
fi

# initialize or upgarde the db
if psql -h $OMERO_DB_HOST -p $OMERO_DB_PORT -U $OMERO_DB_USER -lqt | cut -d \| -f 1 | grep -qw $OMERO_DB_NAME; then
    echo "WARNING: $OMERO_DB_NAME exists."
else
    createdb -h $OMERO_DB_HOST -p $OMERO_DB_PORT -U $OMERO_DB_USER $OMERO_DB_NAME
    echo "INFO: $OMERO_DB_NAME was created."
fi
omego db upgrade --serverdir ${OMEROPATH} --dbname $OMERO_DB_NAME || omego db init --serverdir ${OMEROPATH} --dbname $OMERO_DB_NAME


echo "Creating data repo..."
mkdir -p ${HOME}/data
${OMEROPATH}/bin/omero config set omero.data.dir "${HOME}/data"


echo "Starting OMERO.server..."
${OMEROPATH}/bin/omero admin start --foreground
