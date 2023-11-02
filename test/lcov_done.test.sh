#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./deps/pipetest/pipetest.sh
# shellcheck source=./lcov.sh
source ./lcov.sh -o test/coverage

rm -fr ./test/coverage

lcov_done | assert_equals "$(cat <<EOF
==> Error missing lcov_init bef ore lcov_done.
    lcov_done() at ./lcov.sh:11
    main() at test/lcov_done.test.sh:1
EOF
)"
