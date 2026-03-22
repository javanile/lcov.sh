#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

get_files tests/fixtures/sample.md | assert_equals "$(cat <<EXPECTED
./tests/fixtures/sample.md
EXPECTED
)"

get_files tests/fixtures/sample.sh tests/fixtures/test1.sh tests/fixtures/test2.sh | sort | assert_equals "$(cat <<EXPECTED
./tests/fixtures/sample.sh
./tests/fixtures/test1.sh
./tests/fixtures/test2.sh
EXPECTED
)"
