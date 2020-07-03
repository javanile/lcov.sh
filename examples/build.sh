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

cd examples
(
    echo  "# Examples"
    echo  "..."
) > index.md

cd basic
(
    cp ../../lcov.sh .
    code script.sh
    code script-test.sh
    dump ./lcov.sh script-test.sh
    echo '<iframe width="100%" height="400" src="coverage/"></iframe>'
    rm lcov.sh
) > index.md
cd ..
