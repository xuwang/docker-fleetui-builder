FROM google/golang:1.4
# Install docker.io, 
# It's necessary only when host os is not same as the base image i.e. Debian GNU/Linux 7 (wheezy)

ENV DEBIAN_FRONTEND noninteractive
#ENV FLEETUIREPO github.com/purpleworks/fleet-ui
ENV FLEETUIREPO github.com/xuwang/fleet-ui
ENV FLEETCTL_VERSION v0.9.1

RUN echo 'deb http://http.debian.net/debian wheezy-backports main' >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y  apt-utils \
    && apt-get install --force-yes -y -t wheezy-backports linux-image-amd64 nodejs libpng-dev \
    && update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100 \
    && curl -sSL https://get.docker.com/ | sh \
    && curl -L https://www.npmjs.org/install.sh | sh

RUN npm install angular \
    && npm install -g grunt-cli \
    && npm install -g bower

RUN go get ${FLEETUIREPO} \
    && cp $GOPATH/bin/fleet-ui $GOPATH/src/${FLEETUIREPO}/tmp \
    && cd $GOPATH/src/${FLEETUIREPO}/angular \
    && npm install \
    && bower install --allow-root; bower install --allow-root  \
    && npm build
    
# first bower install will fail, must run bower install twice to fix bootstrap-sass-official dependence problems
RUN cd $GOPATH/src/${FLEETUIREPO}/angular && bower install --allow-root; bower install --allow-root

# Install ruby and compass, requried by grunt.
RUN apt-get install -y ruby-full build-essential rubygems
RUN gem install compass rdoc
RUN cd $GOPATH/src/${FLEETUIREPO}/angular && npm install grunt-contrib-compass --save-dev
RUN cd $GOPATH/src/${FLEETUIREPO}/angular && grunt build --force

# Install fleetctl, and change the fleetctl version in fleet-ui's Dockefile to match
RUN cd $GOPATH/src/${FLEETUIREPO}; \
    curl -s -L https://github.com/coreos/fleet/releases/download/${FLEETCTL_VERSION}/fleet-${FLEETCTL_VERSION}-linux-amd64.tar.gz | tar xz -C tmp/

CMD tag=$(cd ${GOPATH}/src/${FLEETUIREPO}; git rev-parse --short=12 HEAD) \
    && sed -i "s/fleet.*-linux-amd64/fleet-${FLEETCTL_VERSION}-linux-amd64/" ${GOPATH}/src/${FLEETUIREPO}/Dockerfile \
    && docker build -t fleet-ui:$tag ${GOPATH}/src/${FLEETUIREPO} \
    && docker tag fleet-ui:$tag fleet-ui:latest 
