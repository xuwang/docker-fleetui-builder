#!/bin/bash

# First build the fleet-ui-builder image
echo building fleet-ui-builder ...
#docker rmi fleet-ui-builder:latest > /dev/null 2>&1
docker build -t fleet-ui-builder .

# Run the builder image to build fleet-ui docker image
#docker rmi fleet-ui:latest > /dev/null 2>&1
echo building fleet-ui ...
docker run -t --env FLEET_VERSION=v0.9.1 --env FLEETUIREPO=github.com/purpleworks/fleet-ui \
	-v /var/run/docker.sock:/var/run/docker.sock fleet-ui-builder:latest

# Show the build result
docker images fleet-ui
