#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

run echo "Hello World!"
echo "${output}" | assert_equals "Hello World!"
echo "${status}" | assert_equals "0"
