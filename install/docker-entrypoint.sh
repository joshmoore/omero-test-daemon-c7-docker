#!/bin/bash

set -eux

OMEROBUILD=${OMEROBUILD:-}

COMPONENT="${COMPONENT,,}"

OMEROPATH=${OMEROPATH:-"${HOME}/OMERO.${COMPONENT}"}


sudo pip install -r /tmp/install/requirements.txt

echo "Downloading ${OMEROBUILD} OMERO.${COMPONENT}..."

ARGS=""
[ -n "${OMEROBUILD}" ] && ARGS="$ARGS --branch $OMEROBUILD"

(cd /tmp && omego download --ice 3.6 $ARGS $COMPONENT)
omegozip=$(ls /tmp/OMERO.${COMPONENT}*.zip)
omerodist=${omegozip%.zip}
rm -f $omegozip
mv ${omerodist} ${OMEROPATH}

/tmp/install/${COMPONENT}.sh "$@"
