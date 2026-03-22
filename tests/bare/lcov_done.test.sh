#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

rm -fr ./tests/coverage

# Without lcov_init, lcov_done should print error
lcov_done 2>&1 | head -1 | assert_equals "==> Error missing lcov_init before lcov_done."
