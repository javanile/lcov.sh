#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

rm -fr ./tests/coverage
lcov_init tests/fixtures/sample.sh

mkdir -p tests/coverage

# Simulate a passing test: write output to lcov_test_out and a log to lcov_test_log
echo "Hello World!" > "${lcov_test_out}"
touch "${lcov_test_log}"

lcov_test_check tests/fixtures/sample.sh 0 | grep "(done)" | wc -l | assert_equals 1
