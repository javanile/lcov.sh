FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl=7.64.0-4+deb10u1 lcov=1.13-4 make=4.2.1-1.2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sLo- http://get.bpkg.sh | bash

WORKDIR /lcov.sh
