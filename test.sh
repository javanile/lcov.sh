#!/bin/bash
set -e

source lcov.sh "$@"

lcov_init *.sh !test.sh !release.sh !coverage

run_test ./test/lcov_init.sh

lcov_done
