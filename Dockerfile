FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends lcov && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /lcov.sh
