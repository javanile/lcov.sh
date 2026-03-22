#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

# Should include specific file in output
get_files | grep -c "tests/fixtures/sample.sh" | assert_equals 1

# Exclude pattern: should exclude test files
get_files '!tests' | grep "tests/" | wc -l | assert_equals 0
