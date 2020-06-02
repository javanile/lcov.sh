#!/usr/bin/env bash
set -e

source ./deps/pipetest/pipetest.sh
source ./lcov.sh -o test/coverage

get_files ./*.md !./*.sh | assert_equals "$(cat <<EOF
./README.md
EOF
)"

get_files ./test/fixtures/*.sh !deps !lcov.sh !*test.sh | sort | assert_equals "$(cat <<EOF
./test/fixtures/sample.sh
./test/fixtures/test1.sh
./test/fixtures/test2.sh
EOF
)"
