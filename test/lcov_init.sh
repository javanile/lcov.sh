#!/bin/bash
set -e

source lcov.sh -o test/coverage
source test/testcase.sh

echo "Testing"

lcov_init *.sh

assert_directory_exists test/coverage
assert_file_exists test/coverage/lcov.info
