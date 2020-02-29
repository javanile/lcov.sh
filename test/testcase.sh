#!/bin/bash

assert_directory_exists () {
    if [[ ! -d "$1" ]]; then
        echo "Directory '$1' not exists"
        exit 1
    fi
}

assert_file_exists () {
    if [[ ! -f "$1" ]]; then
        echo "File '$1' not exists"
        exit 1
    fi
}

assert_output_equals () {
    row=0
    expect=("$@")
    while read actual; do
        if [[ "${actual}" != "${expect[${row}]}" ]]; then
            echo "Expected '${expect[${row}]}' found '${actual}'"
            exit 1
        fi
        row=$((row+1))
    done
    echo "Assert output equals success"
}
