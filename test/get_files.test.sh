#!/usr/bin/env bash
set -e

source ./deps/pipetest/pipetest.sh
source ./lcov.sh -o test/coverage

get_files ./*.md !./*.sh | assert_equals "$(cat <<EOF
./README.md
EOF
)"
