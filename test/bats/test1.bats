#!/usr/bin/env bats

load test1.sh
load ../../lcov.sh

@test "Testing: test1_func1()" {
    run test1_func1

    [ "${output}" = "TEST1_FUNC1" ]
}

@test "Testing: test1_func2()" {
    run test1_func2

    [ "${output}" = "TEST1_FUNC2" ]
}
