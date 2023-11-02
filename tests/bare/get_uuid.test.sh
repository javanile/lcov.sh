#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./deps/pipetest/pipetest.sh
# shellcheck source=./lcov.sh
source ./lcov.sh -o test/coverage

get_uuid ./*.md !./*.sh | wc -c | assert_equals 37
