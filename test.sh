#!/bin/bash

source lcov.sh "$@"

lcov_init *.sh !test.sh !release.sh !coverage

run_test ./test/lcov_init.sh ./test/lcov_init2.sh
run_test ./test/lcov_init3.sh

lcov_done
