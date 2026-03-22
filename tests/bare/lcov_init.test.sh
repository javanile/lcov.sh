#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

rm -fr ./tests/coverage

# Use a non-existent extension so get_files only picks up the explicit include
lcov_extension=xyz
lcov_init ./tests/fixtures/custom.zsh

echo "./tests/coverage" | assert_directory_exists
echo "./tests/coverage/lcov.info" | assert_file_exists

grep -c "^SF:" ./tests/coverage/lcov.info | assert_equals 1
