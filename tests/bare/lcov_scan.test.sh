#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

lcov_scan tests/fixtures/sample.sh | assert_equals "$(cat <<EXPECTED
TN:
SF:tests/fixtures/sample.sh
DA:2,0
DA:4,0
DA:5,0
end_of_record
EXPECTED
)"
