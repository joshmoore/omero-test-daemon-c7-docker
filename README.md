[![Build Status](https://travis-ci.org/openmicroscopy/omero-test-daemon-c7-docker.svg?branch=master)](https://travis-ci.org/openmicroscopy/omero-test-daemon-c7-docker)


# OMERO test CentOS 7

The OMERO testing server and Python developers environment.

This is a fully functional OMERO.server, based on the recent release.

## How to use it:

To start basic OMERO.server image, run:

```
docker run -d --name postgres postgres
docker run --rm --name omeroserver --link postgres:postgres -p 4064:4064 -p 4063:4063 openmicroscopy/omero-test-daemon-c7
```

To start basic OMERO.server using development branch use: `-e OMEROBUILD=OMERO-DEV-latest`

available branches:

- OMERO-DEV-latest
- OMERO-DEV-merge-build
- OMERO-DEV-breaking-build

For more details see https://ci.openmicroscopy.org/

Note: Ice 3.6 support only

### Run using Docker Compose:


Create `docker-compose.yml`

```
version: '2'
services:
  postgres:
    image: postgres

  omeroserver:
    image: openmicroscopy/omero-test-daemon-c7
    links:
      - postgres
    ports:
      - 4064:4064
      - 4063:4063
```


Add COMPONENT=py to run OMERO.py package

```
  omeropy:
    image: openmicroscopy/omero-test-daemon-c7
    links:
      - omeroserver
    environment:
      - COMPONENT=py
      - SERVER_HOST=omeroserver
      - SERVER_PORT=4064
    command: /home/omero/OmeroPy/bin/omero config get
```

mount your own volume containing OMERO python client, set custom command and run own tests.


Run

```
docker-compose -f docker-compose.yml up
```

## Build:


To build container locally use

```
make
```

## Use:


Include image in your Dockerfile

```
FROM openmicroscopy/omero-test-daemon-c7
```

## Test:


Run tests

```
./runtest
```
