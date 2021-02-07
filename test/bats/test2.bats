#!/usr/bin/env bats

export LCOV_DEBUG_LOG=lcov.log

load test2.sh
load ../../lcov.sh

@test "Testing: test2_func1()" {
    run test2_func1

    [ "${output}" != "TEST2_FUNC1" ]
}

@test "Testing: test2_func2()" {
    run test2_func2

    [ "${output}" = "TEST2_FUNC2" ]
}
