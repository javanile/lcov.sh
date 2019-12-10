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

