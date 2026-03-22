#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

rm -fr ./tests/coverage
lcov_init tests/fixtures/sample.sh

# Test with a non-existent file: should skip
lcov_test non_existent_file.sh 2>/dev/null | grep "(skip)" | wc -l | assert_equals 1

# Test with a directory: should skip
lcov_test tests/fixtures 2>/dev/null | grep "(skip)" | wc -l | assert_equals 1
