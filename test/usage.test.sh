#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./deps/pipetest/pipetest.sh
# shellcheck source=./lcov.sh
source ./lcov.sh -o test/coverage

usage | assert_equals "$(cat <<EOF
Usage: ./lcov.sh [OPTION]... FILE...

Executes FILE as a test case also collect each LCOV info and generate HTML report

List of available options
  -e, --extension EXT     Coverage of every *.EXT file (default: sh)
  -i, --include PATH      Include files matching PATH
  -x, --exclude PATH      Exclude files matching PATH
  -o, --output OUTDIR     Write HTML output to OUTDIR
  -h, --help              Display this help and exit
  -v, --version           Display current version
Documentation can be found at https://github.com/javanile/lcov.sh
EOF
)"
