#!/bin/bash

[[ -z "${LCOV_DEBUG}" ]] || set -x

covered_func() {
  echo "Hello $1!"
}

uncovered_func() {
  echo "Great!"
}

covered_func "World!"
