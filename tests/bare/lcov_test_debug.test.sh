#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

mkdir -p tests/coverage

# lcov_test_debug runs a bash script with -x tracing and captures output/log
lcov_test_debug tests/fixtures/sample.sh && true
cat "${lcov_test_out}" | assert_equals "Hello World!"
