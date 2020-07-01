#!/usr/bin/env bash
set -e

#source ./deps/pipetest/pipetest.sh
source ./lcov.sh -o test/coverage
#set +x
run exit 1
echo "${output}"