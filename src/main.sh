#!/usr/bin/env bash

##
# LCOV.SH
#
# The best LCOV framework around BASH projects.
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

[ -z "${LCOV_DEBUG}" ] || set -x

set -ef

module usage
module utils
module lcov
module test
module bats

VERSION="0.1.0"

# shellcheck disable=SC2016
LCOV_PS4='+:lcov.sh:${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

##
# Initialize environment variables for source mode.
# Call this after sourcing lcov.sh to set up all required globals.
#
# Arguments:
#  - $1: output directory (default: coverage)
##
lcov_env() {
  lcov_output="${1:-coverage}"
  lcov_extension="${lcov_extension:-sh}"
  lcov_coverage=()
  lcov_debug_log="${LCOV_DEBUG_LOG:-}"
  lcov_temp_dir=$(mktemp -d -t lcov-sh-XXXXXXXXXXXX)

  local escape
  case "$(uname -s)" in
    Darwin*) escape='\x1B' ;;
    Linux|*) escape='\e' ;;
  esac

  if [[ -z "${LCOV_DEBUG_NO_COLOR}" ]]; then
    skip_flag="${escape}[37m(skip)${escape}[0m"
    done_flag="${escape}[1m${escape}[32m(done)${escape}[0m"
    fail_flag="${escape}[1m${escape}[31m(fail)${escape}[0m"
  else
    skip_flag="SKIP"
    done_flag="DONE"
    fail_flag="FAIL"
  fi

  lcov_log="${lcov_output}/lcov.log"
  lcov_info="${lcov_output}/lcov.info"
  lcov_files="${lcov_output}/lcov.files"
  lcov_test_log="${lcov_output}/test.log"
  lcov_test_out="${lcov_output}/test.out"
  lcov_test_lock="${lcov_output}/test.lock"
  lcov_test_stat="${lcov_output}/test.stat"
  lcov_test_info="${lcov_output}/test.info"
}

##
# Entry-point
##
main() {
  if [[ -z "$(command -v lcov)" ]]; then
    echo "lcov.sh: missing 'lcov' command on your system. (try: sudo apt install lcov)" >&2
    exit 1
  fi

  if [[ -z "$1" ]]; then
    echo "lcov.sh: missing file to test as test case. (try: lcov.sh test/*-test.sh)" >&2
    exit 1
  fi

  echo "LCOV.SH by Francesco Bianco <bianco@javanile.org>"
  echo ""

  trap '$(jobs -p) || kill $(jobs -p)' EXIT

  local getopt
  local escape
  case "$(uname -s)" in
    Darwin*)
      getopt=/usr/local/opt/gnu-getopt/bin/getopt
      escape='\x1B'
      ;;
    Linux|*)
      [ -x /bin/getopt ] && getopt=/bin/getopt || getopt=/usr/bin/getopt
      escape='\e'
      ;;
  esac

  stop_on_failure=
  lcov_coverage=()
  lcov_extension=sh
  lcov_output=coverage
  lcov_debug_log=${LCOV_DEBUG_LOG}
  lcov_temp_dir=$(mktemp -d -t lcov-sh-XXXXXXXXXXXX)

  if [[ -z "${LCOV_DEBUG_NO_COLOR}" ]]; then
    skip_flag="${escape}[37m(skip)${escape}[0m"
    done_flag="${escape}[1m${escape}[32m(done)${escape}[0m"
    fail_flag="${escape}[1m${escape}[31m(fail)${escape}[0m"
  else
    skip_flag="SKIP"
    done_flag="DONE"
    fail_flag="FAIL"
  fi

  local options
  options=$(${getopt} -n lcov.sh -o i:e:x:o:svh -l extension:,include:,exclude:,output:,stop-on-failure,version,help -- "$@")

  eval set -- "${options}"

  while true; do
    case "$1" in
      -o|--output) shift; lcov_output=$1 ;;
      -i|--include) shift; lcov_coverage+=("$1") ;;
      -x|--exclude) shift; lcov_coverage+=("!$1") ;;
      -e|--extension) shift; lcov_extension=$1 ;;
      -s|--stop-on-failure) stop_on_failure=1 ;;
      -v|--version) echo "LCOV.SH version ${VERSION}"; exit ;;
      -h|--help) usage; exit ;;
      --) shift; break ;;
    esac
    shift
  done

  lcov_log="${lcov_output}/lcov.log"
  lcov_info="${lcov_output}/lcov.info"
  lcov_files="${lcov_output}/lcov.files"
  lcov_test_log="${lcov_output}/test.log"
  lcov_test_out="${lcov_output}/test.out"
  lcov_test_lock="${lcov_output}/test.lock"
  lcov_test_stat="${lcov_output}/test.stat"
  lcov_test_info="${lcov_output}/test.info"

  lcov_init "${lcov_coverage[@]}"

  for test in "$@"; do
    lcov_test "${test}"
  done

  lcov_done
}

