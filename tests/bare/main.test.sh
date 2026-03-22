#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

# main with no args should print error to stderr and exit 1
(main 2>&1 || true) | grep "missing file to test" | wc -l | assert_equals 1
