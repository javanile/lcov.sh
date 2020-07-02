#!/usr/bin/env bash

[[ -z "${LCOV_DEBUG}" ]] || set -x

test1_func1() {
  #>&2 echo "TEST1_FUNC1"
  echo -n "TEST1_FUNC1"
}

test1_func2() {
  echo -n "TEST1_FUNC2"
}
