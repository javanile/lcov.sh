#!/usr/bin/env bash

[ -f "${LCOV_DEBUG}" ] && set -x

test1_func1() {
  echo -n "TEST1_FUNC1"
}

test1_func2() {
  echo -n "TEST1_FUNC2"
}
