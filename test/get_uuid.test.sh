#!/usr/bin/env bash
set -e

source ./deps/pipetest/pipetest.sh
source ./lcov.sh -o test/coverage

get_uuid ./*.md !./*.sh | wc -c | assert_equals 37
