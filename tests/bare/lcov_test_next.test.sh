#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

mkdir -p tests/coverage
touch "${lcov_test_lock}"

# lcov_test_next should remove the lock file
lcov_test_next
[[ ! -f "${lcov_test_lock}" ]] && echo "lock removed" | assert_equals "lock removed"
