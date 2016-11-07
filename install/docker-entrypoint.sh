#!/bin/bash

set -eux

sudo pip install -r /tmp/install/requirements.txt

COMPONENT="${COMPONENT,,}"

echo "Downloading OMERO.${COMPONENT}..."
(cd /tmp && omego download --ice 3.6 --branch ${OMEROBUILD} ${COMPONENT})
omegozip=$(ls /tmp/OMERO.${COMPONENT}*.zip)
omerodist=${omegozip%.zip}
rm -f $omegozip
OMEROPATH=${HOME}/Omero${COMPONENT~}
mv ${omerodist} ${OMEROPATH}

/tmp/install/${COMPONENT}.sh "$@"
