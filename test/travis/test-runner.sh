#!/usr/bin/env bash
set -e

## Alpine
if command -v apk &> /dev/null; then
  apk add \
    --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    make lcov
fi

echo "========================================"
bash --version
echo "========================================"

make test-bats
