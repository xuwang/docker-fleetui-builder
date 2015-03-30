# Build fleet-ui docker image

This a 'builder' image to build [purpleworks/fleet-ui](https://github.com/purpleworks/fleet-ui.git). If you forked the repo, change the Dockerfile's ENV FLEETUIREPO to reference your forked repo.
 
## Quick start

	docker pull xuwang/docker-fleetui-builder
	docker run --rm  -v /var/run/docker.sock:/var/run/docker.sock xuwang/docker-fleetui-builder:latest 

  The result image is called _fleet-ui:latest_ which you can run in a container, or tag and push to a dockerhub.

## Run the fleet-ui on CoreOS

Here is an example of how to [Run fleet-ui on CoreOS.](https://github.com/xuwang/coreos-docker-dev/blob/master/README-fleet-ui.md)

## Build it yourself

If you want to build everything yourself, clone the builder repo from [docker-fleetui-builder](https://github.com/xuwang/docker-fleetui-builder).
Before build, edit FLEETUIREPO environment variable in in compile-build.sh to your forked fleet-ui repo. I forked _fleet-ui_ repo from [fleet-ui](https://github.com/purpleworks/fleet-ui.git) and updated fleetctl to 0.9.1., among other things.

	FLEETUIREPO github.com/xuwang/fleet-ui

Then run:

	https://github.com/xuwang/docker-fleetui-builder
	./build.sh

It builds two images. The first one is _fleet-ui-builder_, and then the script calls it to build _fleet-ui_.

## How does it work

The builder Dockerfile creates an isolated docker enviromment, with the software packages and docker daemon installed. The result 
image is called _fleet-ui-builder_ which, when run, will build _fleet-ui_ docker image. _fleet-ui_ image is the one you will run or push to your dockerhub account to share. 

The builder environment includes:

* golang 1.4
* npm, ruby, gem etc.
* docker from Debian/Wheezy release
* fleetctl 0.9.1 
* fleet-ui binary compiled from repo defined at the top of the Dockerfile

The builder image can be removed when you are sure you have a good fleet-ui image: 

	docker rmi fleet-ui-builder:latest

## Troubleshoot

If you have problem with the fleet-ui, you can debug your build environment by run the builder image:

	docker run --rm -i -t fleet-ui-builder bash

The fleet-ui source code downloaded by Go is located at /gopath directory:

![fleet-ui src tree](https://github.com/xuwang/docker-fleetui-builder/blob/master/images/fleet-ui-src.png "fleet-ui src tree")

Then you can manually run steps in the builder Dockerfile for troubleshooting issues.
