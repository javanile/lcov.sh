#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

mkdir -p tests/coverage
rm -f "${lcov_test_stat}"

# Add first result: 1 test, 1 done, 0 fail, 0 skip
lcov_test_stat 1 1 0 0
cat "${lcov_test_stat}" | assert_equals "1 1 0 0"

# Add second result: 1 test, 0 done, 1 fail, 0 skip → cumulative: 2 1 1 0
lcov_test_stat 1 0 1 0
cat "${lcov_test_stat}" | assert_equals "2 1 1 0"

# Add skipped: 1 test, 0 done, 0 fail, 1 skip → cumulative: 3 1 1 1
lcov_test_stat 1 0 0 1
cat "${lcov_test_stat}" | assert_equals "3 1 1 1"
