#!/bin/bash

REPO=${1:-github.com/purpleworks/fleet-ui}

# First build the fleet-ui-builder image
echo building fleet-ui-builder ...
docker rmi fleet-ui-builder:latest > /dev/null 2>&1
if [ -z "${http_proxy}" ]; then
  docker build -t fleet-ui-builder .
else
  docker build --build-arg http_proxy=${http_proxy} --build-arg https_proxy=${https_proxy} -t fleet-ui-builder .
fi

# Run the builder image to build fleet-ui docker image
echo building fleet-ui ...
docker rmi fleet-ui:latest > /dev/null 2>&1
docker run -t --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --env FLEET_VERSION=v0.11.5 \
  --env FLEETUIREPO=$REPO \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --dns 8.8.8.8 \
  fleet-ui-builder:latest

# Show the build result
docker images fleet-ui
