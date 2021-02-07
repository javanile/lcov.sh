
load test1.sh
load ../../lcov.sh

#lcov_init

@test "test1 func1" {
    run test1_func1
    echo "${output}" > a.txt

    [ "${output}" = "TEST1_FUNC1" ]

}
