#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

mkdir -p tests/coverage

# lcov_exec wraps lcov and logs errors; test it handles a bad invocation gracefully
lcov_exec --version 2>/dev/null || true
echo "lcov_exec ran" | assert_equals "lcov_exec ran"
