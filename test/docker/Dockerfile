FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates=20190110 \
        curl=7.64.0-4+deb10u1 \
        git=1:2.20.1-2+deb10u3 \
        lcov=1.13-4 \
        make=4.2.1-1.2 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://git.io/get-bpkg | bash -

WORKDIR /lcov.sh
