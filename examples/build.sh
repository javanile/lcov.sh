#!/bin/bash

export LCOV_DEBUG_NO_COLOR=yes

code() {
    echo '> File: `' $1 '`'
    echo '```bash'
    cat $1
    echo '```'
}

dump() {
    echo '```'
    echo "$ $@"
    "$@"
    echo '```'
}

##
cd examples/basic
(
    rm -fr coverage
    code script.sh
    code script-test.sh
    dump ../../lcov.sh script-test.sh
    echo '<iframe width="100%" height="400" src="coverage/basic"></iframe>'
) > index.md
cd ../..
