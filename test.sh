#!/bin/bash

source lcov.sh $@

lcov_init *.sh !test.sh !coverage

run_test ./test/lcov_init.sh
#run_test ./test/lcov_init.sh

lcov_done
