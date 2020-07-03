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
    code script.sh
    code script.test.sh
    dump ls
    echo '<iframe width="100%" height="400" src="basic/coverage/"></iframe>'
) >> ../index.md
cd ..
