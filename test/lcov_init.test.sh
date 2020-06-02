#!/usr/bin/env bash
set -e

source ./deps/pipetest/pipetest.sh
source ./lcov.sh -o test/coverage

rm -fr ./test/coverage

lcov_init ./*.sh >/dev/null

assert_directory_exists ./test/coverage
assert_file_exists ./test/coverage/lcov.info
