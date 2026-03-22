#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

rm -fr ./tests/coverage
lcov_init tests/fixtures/sample.sh

# Create a minimal debug log that simulates a covered line
tmp_log=$(mktemp)
echo "+:lcov.sh:tests/fixtures/sample.sh:2: " >> "${tmp_log}"

lcov_append_info "${tmp_log}"

# After appending, lcov.info should still exist and be valid
echo "./tests/coverage/lcov.info" | assert_file_exists
rm -f "${tmp_log}"
