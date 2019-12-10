FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends lcov=1.13-4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /lcov.sh
