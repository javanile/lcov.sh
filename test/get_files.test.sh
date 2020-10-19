#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./deps/pipetest/pipetest.sh
# shellcheck source=./lcov.sh
source ./lcov.sh -o test/coverage

get_files ./test/fixtures/*.md !./*.sh | assert_equals "$(cat <<EOF
./test/fixtures/sample.md
EOF
)"

get_files ./test/fixtures/*.sh !deps !lcov.sh !*test.sh !example* !test/bats* | sort | assert_equals "$(cat <<EOF
./test/fixtures/sample.sh
./test/fixtures/test1.sh
./test/fixtures/test2.sh
EOF
)"
