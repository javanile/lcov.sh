#!/bin/bash

code() {
    echo '```bash'
    cat $1
    echo '```'
}

dump() {
    echo '```bash'
    echo "$ $@"
    "$@"
    echo '```'
}

##
cd examples/basic
(
    cp ../../lcov.sh .
    rm -fr coverage
    code script.sh
    code script-test.sh
    dump ./lcov.sh script-test.sh
    echo '<iframe width="100%" height="400" src="coverage/"></iframe>'
    rm lcov.sh
) > index.md
cd ../..
