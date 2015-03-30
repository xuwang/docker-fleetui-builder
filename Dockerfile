FROM google/golang:1.4
MAINTAINER Xu Wang <xuwang@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
#ENV FLEETUIREPO github.com/purpleworks/fleet-ui
ENV FLEETUIREPO github.com/xuwang/fleet-ui
ENV FLEETCTL_VERSION v0.9.1

# Install docker.io, 
# It's necessary only when host os is not same as the base image i.e. Debian GNU/Linux 7 (wheezy)
RUN echo 'deb http://http.debian.net/debian wheezy-backports main' >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --force-yes -y apt-utils ruby-full build-essential rubygems \
    && apt-get install --force-yes -y -t wheezy-backports linux-image-amd64 nodejs libpng-dev \
    && update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100 \
    && curl -sSL https://get.docker.com/ | sh \
    && curl -L https://www.npmjs.org/install.sh | sh \
    && gem install compass rdoc

RUN npm install angular \
    && npm install -g grunt-cli \
    && npm install -g bower

ADD compile-build.sh /root/compile-build.sh
RUN chmod 755 /root/compile-build.sh

WORKDIR /root
CMD ./compile-build.sh
