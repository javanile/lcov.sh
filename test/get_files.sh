#!/bin/bash
set -e

source ./test/testcase.sh
source ./lcov.sh -o test/coverage

get_files ./*.md !./*.sh ./test/fixtures/*.sh

