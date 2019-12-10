#!/bin/bash
set -e

source lcov.sh -o test/coverage

lcov_init *.sh >/dev/null

echo "Yes"

exit 1
