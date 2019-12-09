#!/bin/bash

source lcov.sh

lcov_init *.sh !test.sh !coverage

run_test ./test/test1.sh

lcov_done
