#!/bin/bash
set -e

source ./test/testcase.sh
source ./lcov.sh -o test/coverage

get_files ./*.md !./*.sh | assert_output_equals $(cat <<EOF
    ./README.md
EOF
)
