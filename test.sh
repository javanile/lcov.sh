#!/bin/bash
set -e

source lcov.sh "$@"

lcov_init *.sh !test.sh !release.sh !coverage

run_test ./test/lcov_init.sh
#run_test ./test/fixtures/test1.sh ./test/test2.sh

lcov_done
