#!/bin/bash

# First build the fleet-ui-builder image
docker rmi fleet-ui-builder:latest > /dev/null 2>&1
docker build -t fleet-ui-builder .

# Run the builder image to build fleet-ui docker image
docker rmi fleet-ui:latest > /dev/null 2>&1
docker run --rm  -v /var/run/docker.sock:/var/run/docker.sock fleet-ui-builder:latest

# Show the build result
docker images 
