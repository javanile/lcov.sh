#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./deps/pipetest/pipetest.sh
# shellcheck source=./lcov.sh
source ./lcov.sh -o test/coverage

lcov_scan test/fixtures/sample.sh | assert_equals "$(cat <<EOF
TN:
SF:test/fixtures/sample.sh
DA:2,0
DA:4,0
DA:5,0
end_of_record
EOF
)"
