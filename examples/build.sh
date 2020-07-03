#!/bin/bash

code() {
    echo '```bash'
    cat $1
    echo '```'
}

dump() {
    echo '```bash'
    echo "$ $@"
    "$@" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
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
    echo '<iframe width="100%" height="400" src="coverage/basic"></iframe>'
    rm lcov.sh
) > index.md
cd ../..
