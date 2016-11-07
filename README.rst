.. image:: https://travis-ci.org/aleksandra-tarkowska/omero-test-daemon-c7-docker.svg?branch=master
    :target: https://travis-ci.org/aleksandra-tarkowska/omero-test-daemon-c7-docker



OMERO test daemon CentOS 7
==========================

Run:
----

To start basic OMERO.server image, run:

    docker run -d --name postgres postgres
    docker run --rm --name omeroserver --link postgres:postgres --port 4064:4064 --port 4063:4063 openmicroscopy/omero-test-daemon-c7

Note: Ice 3.6 support only

Run using Docker Compose:
-------------------------

Create `docker-compose.yml`::

    version: '2'
    services:
      postgres:
        image: postgres

      omeroserver:
        image: openmicroscopy/omero-test-daemon-c7
        links:
          - postgres

Add COMPONENT=py to run OMERO.py package.

      omeropy:
        image: openmicroscopy/omero-test-daemon-c7
        links:
          - omeroserver
        environment:
          - COMPONENT=py
          - SERVER_HOST=omeroserver
          - SERVER_PORT=4064
        command: /home/omero/OmeroPy/bin/omero config get

mount your own volume containing OMERO python client, set custom command and run own tests.

Run::

    docker-compose -f docker-compose.yml up


Build:
------

To build container locally use::

    make start


Use:
----

Include image in your Dockerfile

    FROM openmicroscopy/omero-test-daemon-c7

Test:
-----

    ./runtest
