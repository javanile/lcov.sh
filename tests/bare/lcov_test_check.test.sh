#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh

lcov_extension=xyz
LCOV_DEBUG_NO_COLOR=1
lcov_env tests/coverage
rm -fr ./tests/coverage
lcov_init ./tests/fixtures/custom.zsh

# Simulate a passing test: write some output to the test files
echo "Hello World!" > "${lcov_test_out}"
touch "${lcov_test_log}"

# Check that done flag appears for exit code 0
lcov_test_check tests/fixtures/sample.sh 0 | grep "(ok)" | wc -l | assert_equals 1

# Reset stat file for clean failure test
rm -f "${lcov_test_stat}"

# Check that fail flag appears for exit code 1
lcov_test_check tests/fixtures/sample.sh 1 | grep "exit 1" | wc -l | assert_equals 1
