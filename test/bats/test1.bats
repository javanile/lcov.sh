
load test1.sh
load ../../lcov.sh
#load node_modules/.bin/lcov.sh

@test "testing: test1_func1()" {
    run test1_func1

    [ "${output}" = "TEST1_FUNC1" ]
}

@test "testing: test1_func2()" {
    run test1_func2

    [ "${output}" = "TEST1_FUNC2" ]
}
