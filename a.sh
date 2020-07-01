#!/bin/bash

(
    set -x
    echo "AA"
    set +x
) > a.txt 2>&1


echo "BB"
