#!/bin/bash
set -e

source ./lcov.sh -o test/coverage
source ./deps/pipetest/pipetest.sh

get_files ./*.md !./*.sh | assert_equals "$(cat <<EOF
./README.md
EOF
)"
