#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

mkdir -p tests/coverage
rm -f "${lcov_test_lock}"

# No lock file present — lcov_test_wait should complete immediately and create lock
lcov_test_wait
echo "./tests/coverage/test.lock" | assert_file_exists
