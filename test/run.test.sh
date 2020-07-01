#!/usr/bin/env bash
set -e

source ./deps/pipetest/pipetest.sh
source ./lcov.sh -o test/coverage

run echo "Hello World!"
echo ">>> ${output}"
