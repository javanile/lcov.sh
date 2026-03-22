#!/usr/bin/env bash

##
# Pipetest
#
# Assertions through pipe chaining.
#
# Copyright (c) 2020 Francesco Bianco <bianco@javanile.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##

set -e

[[ -f "${LCOV_DEBUG}" ]] && set -x

VERSION="0.1.0"
SOURCED="${BASH_SOURCE[0]}"
[[ "${SOURCED}" = "$0" ]] && SOURCED=

##
# Check if pipe input is empty.
##
assert_empty() {
  local actual_row=0

  while read -r actual; do
    if [[ -n "${actual}" ]]; then
      echo -n "Asserting error: expected empty input, actual contains \"${actual}\" "
      [[ -n "${SOURCED}" ]] && echo "in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" || echo "from STDIN"
      exit 1
    fi
  done && true

#  echo "AR: ${actual_row}"

  if [[ "${actual_row}" != "0" ]]; then
    echo -n "Asserting error: expected empty actual is \"${actual}\" "
    [[ -z "${PIPETEST_STDIN}" ]] && echo "in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" || echo "from STDIN"
    exit 1
  fi

  [[ -z "$1" ]] && echo "Found empty value as expected" || echo "$1"
}

##
# Check if pipe input is empty.
##
assert_not_empty() {
  local actual_row=0

  while read -r actual; do
    if [[ -n "${actual}" ]]; then
      echo -n "Asserting error: expected empty input, actual contains \"${actual}\" "
      [[ -z "${PIPETEST_STDIN}" ]] && echo "in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" || echo "from STDIN"
      exit 1
    fi
  done && true

#  echo "AR: ${actual_row}"

  if [[ "${actual_row}" != "0" ]]; then
    echo -n "Asserting error: expected empty actual is \"${actual}\" "
    [[ -z "${PIPETEST_STDIN}" ]] && echo "in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" || echo "from STDIN"
    exit 1
  fi

  [[ -z "$1" ]] && echo "Found empty value as expected" || echo "$1"
}

##
#
##
assert_equals () {
  local actual_row=0
  local expect_row=0

  declare -a expect
  while read -r line; do
    expect[${expect_row}]="${line}"
    ((expect_row++))
  done < <(echo "$1") && true

  while read -r actual; do
    echo "DIFF[${actual_row}]: ${actual} <-> ${expect[${actual_row}]}"
    if [[ "${actual}" != "${expect[${actual_row}]}" ]]; then
      if [[ -z "$2" ]]; then
          echo -n "Asserting error: expected \"${expect[${actual_row}]}\" actual \"${actual}\" "
      else
          echo -n "$2 "
      fi
      [[ -z "${PIPETEST_STDIN}" ]] && echo "in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" || echo "from STDIN"
      exit 1
    fi
    ((actual_row++))
  done && true

  if [[ "${actual_row}" = "0" ]]; then
    if [[ -z "$2" ]]; then
      echo -n "Asserting error: expected \"$1\" actual is empty "
    else
      echo -n "$2 "
    fi
    [[ -z "${PIPETEST_STDIN}" ]] && echo "in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" || echo "from STDIN"
    exit 1
  fi

  [[ -z "$3" ]] && echo "Exact match over ${actual_row} line" || echo "$3"
}

##
#
##
assert_not_equals () {
  local actual_row=0
  local expect_row=0

  declare -a expect
  while read -r line; do
    expect[${expect_row}]="${line}"
    ((expect_row++))
  done < <(echo "$1") && true

  while read -r actual; do
    echo "DIFF[${actual_row}]: ${actual} <-> ${expect[${actual_row}]}"
    if [[ "${actual}" != "${expect[${actual_row}]}" ]]; then
      if [[ -z "$2" ]]; then
          echo -n "Asserting error: expected \"${expect[${actual_row}]}\" actual \"${actual}\" "
      else
          echo -n "$2 "
      fi
      [[ -z "${PIPETEST_STDIN}" ]] && echo "in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" || echo "from STDIN"
      exit 1
    fi
    ((actual_row++))
  done && true

  if [[ "${actual_row}" = "0" ]]; then
    if [[ -z "$2" ]]; then
      echo -n "Asserting error: expected \"$1\" actual is empty "
    else
      echo -n "$2 "
    fi
    [[ -z "${PIPETEST_STDIN}" ]] && echo "in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" || echo "from STDIN"
    exit 1
  fi

  [[ -z "$3" ]] && echo "Exact match over ${actual_row} line" || echo "$3"
}

##
#
##
assert_file_exists () {
  local failure_message="$1"
  [[ -z "$1" ]] && local failure_message="File '{}' does not exists."
  assert_exists file "${failure_message}" "$2"
}

##
# Assert if file exists
#
# Arguments
#  - $1: Directory name
# Output
#  - if directory not exists print an error message
#  - else newline
##
assert_directory_exists() {
  local failure_message="$1"
  [[ -z "$1" ]] && local failure_message="Directory '{}' does not exists."
  assert_exists directory "${failure_message}" "$2"
}

##
# Assert if directory exists
#
# Arguments
#  - $1: Directory name
# Output
#  - if directory not exists print an error message
#  - else newline
##
assert_exists() {
  local input=
  local actual_count=0
  local expect_count=0
  while read -r actual; do
    actual=$(echo "${actual}" | xargs)
    [[ -z "${actual}" ]] && continue
    case "$1" in
      file)      [[ -f "${actual}" ]] && ((actual_count++)) || input="${actual}" ;;
      directory) [[ -d "${actual}" ]] && ((actual_count++)) || input="${actual}" ;;
    esac
    ((expect_count++))
  done && true

  if [[ ${expect_count} -eq 0 ]]; then
    echo "No input data was detected" && exit 1
  elif [[ ${actual_count} -lt ${expect_count} ]]; then
    assert_failure "${input}" "$2" "Directory '{}' does not exists."
  else
    assert_success "$3"
  fi
}

##
#
##
assert_success() {
  [[ -n "$1" ]] && echo "$1" || true
}

##
#
##
assert_failure() {
  [[ -n "$2" ]] && echo "${2//\{\}/$1}" || echo "${3//\{\}/$1}"
  exit 1
}

##
# If input is provided by STDIN
##
assert_file_not_exists() {
  echo "assert_file_not_exists: not implemented" >&2
  exit 1
}

assert_directory_not_exists() {
  echo "assert_directory_not_exists: not implemented" >&2
  exit 1
}

if [[ -n "${SOURCED}" ]]; then
  export -f assert_empty
  export -f assert_not_empty
  export -f assert_equals
  export -f assert_not_equals
  export -f assert_file_exists
  export -f assert_file_not_exists
  export -f assert_directory_exists
  export -f assert_directory_not_exists
else
  case ${1} in
    assert_empty) assert_empty "${@:2}" ;;
    assert_not_empty) assert_not_empty "${@:2}" ;;
    assert_equals) assert_equals "${@:2}" ;;
    assert_not_equals) assert_not_equals "${@:2}" ;;
    assert_file_exists) assert_file_exists "${@:2}" ;;
    assert_file_not_exists) assert_file_not_exists "${@:2}" ;;
    assert_directory_exists) assert_directory_exists "${@:2}" ;;
    assert_directory_not_exists) assert_directory_not_exists "${@:2}" ;;
    --version) echo "Pipetest ${VERSION} (${0})" ;;
    *) echo "Syntax error: require assert directive (eg. ... | pipetest.sh assert_equals)" ;;
  esac
fi