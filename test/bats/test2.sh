#!/usr/bin/env bash

[ -f "${LCOV_DEBUG}" ] && set -x

test2_func1() {
  echo -n "TEST2_FUNC1"
}

test2_func2() {
  echo -n "TEST2_FUNC2"
}
