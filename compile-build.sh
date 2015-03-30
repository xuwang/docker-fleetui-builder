#!/bin/bash

#FLEETUIREPO=github.com/purpleworks/fleet-ui
FLEETUIREPO=github.com/xuwang/fleet-ui
FLEETCTL_VERSION=v0.9.1

go get ${FLEETUIREPO} \
    && cp $GOPATH/bin/fleet-ui $GOPATH/src/${FLEETUIREPO}/tmp \
    && cd $GOPATH/src/${FLEETUIREPO}/angular \
    && bower install --allow-root \
    && npm install
    
# first bower install will fail, must run bower install twice to fix bootstrap-sass-official dependence problems
cd $GOPATH/src/${FLEETUIREPO}/angular \
    && bower install --allow-root \
    && npm install grunt-contrib-compass --save-dev \
    && npm install npm install --save-dev load-grunt-tasks -save-dev \
    && grunt build --force

# Install fleetctl, and change the fleetctl version in fleet-ui's Dockefile to match
cd $GOPATH/src/${FLEETUIREPO}; \
    curl -s -L https://github.com/coreos/fleet/releases/download/${FLEETCTL_VERSION}/fleet-${FLEETCTL_VERSION}-linux-amd64.tar.gz | tar xz -C tmp/

tag=$(cd ${GOPATH}/src/${FLEETUIREPO}; git rev-parse --short=12 HEAD) 
sed -i "s/fleet.*-linux-amd64/fleet-${FLEETCTL_VERSION}-linux-amd64/" ${GOPATH}/src/${FLEETUIREPO}/Dockerfile 

docker build -t fleet-ui:$tag ${GOPATH}/src/${FLEETUIREPO} \
    && docker tag fleet-ui:$tag fleet-ui:latest 
