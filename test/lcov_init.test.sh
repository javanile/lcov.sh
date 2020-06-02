#!/usr/bin/env bash
set -e

source ./deps/pipetest/pipetest.sh
source ./lcov.sh -o test/coverage

rm -fr ./test/coverage

lcov_init ./test/fixtures/subdir/*.zsh !lcov.sh !deps !*test.sh | assert_equals "LCOV.SH by Francesco Bianco <bianco@javanile.org>"

assert_directory_exists ./test/coverage
assert_file_exists ./test/coverage/lcov.info

grep -e "^SF:" ./test/coverage/lcov.info | assert_equals "$(cat <<EOF
SF:./test/fixtures/sample.sh
SF:./test/fixtures/subdir/custom1.zsh
SF:./test/fixtures/test1.sh
SF:./test/fixtures/test2.sh
EOF
)"
