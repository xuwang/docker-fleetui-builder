#!/bin/sh

FLEETUIREPO=${FLEETUIREPO:-github.com/purpleworks/fleet-ui}
FLEET_VERSION=${FLEET_VERSION:-v0.9.1}
DOCKER_IMAGE_VERSION=${DOCKER_IMAGE_VERSION:-"latest"}


# echo
echo "FLEET-UI REPO - "$FLEETUIREPO
echo "FLEET VERSION - "$FLEET_VERSION
echo "BUILD DOCKER IMAGE VERSION - "$DOCKER_IMAGE_VERSION

# Get and compile FLEET-UI
go get ${FLEETUIREPO}
WORK_DIR=${GOPATH}/src/${FLEETUIREPO}
cp ${GOPATH}/bin/fleet-ui ${WORK_DIR}/tmp

# Build angular
cd ${WORK_DIR}/angular
npm install
bower install --allow-root --config.interactive=false
grunt build

# Get fleet release
cd ${WORK_DIR}
curl -s -L https://github.com/coreos/fleet/releases/download/${FLEET_VERSION}/fleet-${FLEET_VERSION}-linux-amd64.tar.gz | \
	tar xz fleet-${FLEET_VERSION}-linux-amd64/fleetctl -O > tmp/fleetctl
chmod +x tmp/fleetctl

# Build fleet-ui
docker build -t fleet-ui:${DOCKER_IMAGE_VERSION} .
