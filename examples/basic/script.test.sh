#!/bin/bash


(
    echo  "# Examples"
    echo  "..."
) > index.md

(
    echo '```bash'
    cat basic/script.sh
    echo '```'
) >> index.md
