#!/bin/bash
set -e

source lcov.sh -o test/coverage

lcov_init *.sh >/dev/null

exit 1
