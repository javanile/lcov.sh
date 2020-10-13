#!/usr/bin/env bash
set -e

if [[ -n "$(grep -e "^/home/francesco/Develop/Javanile/lcov.sh/examples/basic/script-test.s$" "coverage/lcov.files" && true)" ]]; then
  echo "A"
else
  echo "B"
fi
