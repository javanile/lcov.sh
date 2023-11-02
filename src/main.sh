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

[ -n "${LCOV_DEBUG}" ] && set -x

set -ef

module usage

VERSION="Mush v0.1.0"

# shellcheck disable=SC2016
LCOV_PS4='+:lcov.sh:${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

##
# Generate UUID.
#
# Arguments
#  - None
# Outputs
#  - UUID random code
##
get_uuid ()  {
  if [[ -f /proc/sys/kernel/random/uuid ]]; then
    cat /proc/sys/kernel/random/uuid
  else
    /usr/bin/uuidgen
  fi
  return 0
}

##
# Get all files for coverage analysis.
#
# Arguments
#  - $1...$N: include or exclude glob or path (eg: *.sh, !test, etc...)
# Outputs
#  - Create output directory with scanned tracefile lcov.info file.
##
get_files () {
  local include="-name *.${lcov_extension}"
  local exclude="-not -wholename ${lcov_output} -not -path .git"

  for arg in "$@"; do
    #echo "ARG: ${arg}"
    if [[ "${arg::1}" != "!" ]]; then
      include+=" -or -wholename ${arg}"
    else
      exclude+=" -not -wholename ${arg:1} -not -path *${arg:1}*"
    fi
  done

  find . -type f \( ${include[0]} \) \( ${exclude[0]} \)

  return 0
}

##
#
##
log() {
  if [[ -n "${lcov_debug_log}" ]]; then
    if [[ ! -f "${lcov_debug_log}" ]]; then
      touch "${lcov_debug_log}"
      lcov_debug_log="$(realpath "${lcov_debug_log}")"
      echo "$(date +"%F %T") INIT_LOG ${lcov_debug_log}" >> "${lcov_debug_log}"
    fi
    echo "$(date +"%F %T") $@" >> "${lcov_debug_log}"
  fi
}

##
#
##
error() {
   echo "==> $1"
   local i
   local stack_size=${#FUNCNAME[@]}
   for (( i=1; i<$stack_size ; i++ )); do
      local func="${FUNCNAME[$i]}"
      [ x$func = x ] && func=MAIN
      #local linen="${BASH_LINENO[(( i - 1 ))]}"
      local linen="${BASH_LINENO[$i]}"
      local src="${BASH_SOURCE[$i]}"
      [ x"$src" = x ] && src=non_file_source
      echo "    ${func}() at ${src}:${linen}"
   done
}

##
#
##
lcov_exec() {
  local log=$(lcov "${@}" 2>&1 && true)
  if [[ -n ${log} ]]; then
    lcov_error "${log}" >> "${lcov_log}"
  fi
}

##
# Initialize output directory.
#
# Arguments
#  - $1...$N: include or exclude glob or path (eg: *.sh, !test, etc...)
# Outputs
#  - Create output directory with scanned trace file lcov.info file.
##
lcov_init() {
  mkdir -p "${lcov_output}"
  rm -f "${lcov_info}" "${lcov_files}" "${lcov_test_stat}" "${lcov_test_lock}"

  local init_info="${lcov_output}/init.info"

  get_files "$@" | while IFS= read -r file; do
    readlink -f "${file}" >> "${lcov_files}"
    lcov_scan "${file}" > "${init_info}"
    [[ -f "${lcov_info}" ]] || lcov_exec -q -a "${init_info}" -o "${lcov_info}" && true
    lcov_exec -q -a "${init_info}" -a "${lcov_info}" -o "${lcov_info}"
    rm -f "${init_info}"
  done

  return 0
}

##
# Scan file and generate default lcov file info.
#
# Arguments
#  - $1: file to scan.
# Outputs
#  - LCOV rules from file.
##
lcov_scan() {
  local lineno=0
  local skip_eof=

  echo "TN:"
  echo "SF:$1"

  while IFS= read line || [[ -n "${line}" ]]; do
    #line=${line%%*( )}
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    lineno=$((lineno + 1))
    [[ -z "${line}" ]] && continue
    [[ "${line}" == "else" ]] && continue
    [[ "${line}" == "fi" ]] && continue
    [[ "${line}" == ";;" ]] && continue
    [[ "${line}" == "esac" ]] && continue
    [[ "${line}" == "done" ]] && continue
    [[ "${line::1}" == "#" ]] && continue
    [[ "${line::1}" == "}" ]] && continue
    [[ "${line}" == *"{" ]] && continue
    [[ "${line}" == "EOF" ]] && skip_eof= && continue
    [[ "${skip_eof}" == "EOF" ]] && continue
    [[ "${line}" == *"<<EOF" ]] && skip_eof=EOF
    echo "DA:${lineno},0"
  done < "$1"

  echo "end_of_record"

  return 0
}

##
# Print-out summary of tests.
#
# Arguments:
#  - no args
# Outputs:
#  - Show LCOV summary with tests information
##
lcov_done() {
  if [[ -f "${lcov_info}" ]]; then
    echo ""
    stat="0 0 0 0"
    [[ -f "${lcov_output}/test.stat" ]] && stat="$(cat ${lcov_output}/test.stat && true)"
    test="$(echo ${stat} | cut -s -d' ' -f1)"
    done="$(echo ${stat} | cut -s -d' ' -f2)"
    fail="$(echo ${stat} | cut -s -d' ' -f3)"
    skip="$(echo ${stat} | cut -s -d' ' -f4)"
    if [[ ${fail} -gt 0 || ${done} -eq 0 ]]; then
      exit_info="${fail_flag}"
      exit_code=1
    else
      exit_info="${done_flag}"
      exit_code=0
    fi
    genhtml -q -o "${lcov_output}" "${lcov_output}/lcov.info" && true
    lcov --summary "${lcov_output}/lcov.info"
    echo -e "  tests......: ${test} (${done} done, ${fail} fail, ${skip} skip)"
    echo -e "  exit.......: ${exit_code} ${exit_info}"
    exit ${exit_code}
  else
    error "Error missing lcov_init before lcov_done."
  fi
}

##
#
##
lcov_test_wait() {
  while [[ -f "${lcov_test_lock}" ]]; do sleep 2; done
  touch "${lcov_test_lock}"
  return 0
}

##
#
##
lcov_test_next() {
  rm -f ${lcov_output}/test.lock
  return 0
}

##
# Store running tests stat.
##
lcov_test_stat () {
  local stat="0 "
  [[ -f "${lcov_test_stat}" ]] && stat+="$(cat "${lcov_test_stat}")"

  local test=$(expr $(echo ${stat} | cut -d' ' -f2) + $1 || true)
  local done=$(expr $(echo ${stat} | cut -d' ' -f3) + $2 || true)
  local fail=$(expr $(echo ${stat} | cut -d' ' -f4) + $3 || true)
  local skip=$(expr $(echo ${stat} | cut -d' ' -f5) + $4 || true)

  echo "${test} ${done} ${fail} ${skip}" > "${lcov_test_stat}"

  return 0
}

##
# Execute test case and process LCOV info.
##
lcov_test() {
  if [[ -n "$1" ]]; then
    lcov_test_wait
    echo -n "  > "
    if [[ -f "$1" ]]; then
      lcov_test_debug "$1" && true
      lcov_test_check "$1" "$?"
    else
      if [[ -d "$1" ]]; then
        echo -e "${skip_flag} $1/: is directory.";
      else
        echo -e "${skip_flag} $1: file not found.";
      fi
      lcov_test_stat 1 0 0 1
    fi
    shift
    lcov_test_next
    lcov_test "$@"
  fi
  return 0
}

##
# $1 - Test file
# $2 - Log file
# $3 - Output file
##
lcov_test_debug () {
  local orig_ps4="${PS4}"
  local orig_lcov_debug="${LCOV_DEBUG}"
  local log_file=${lcov_tmp}/run.log

  export LCOV_DEBUG=1
  export PS4="${LCOV_PS4}"

  ## Execute test as bash script and capture output and logs
  bash -x "$1" > "${lcov_test_out}" 2> "${lcov_test_log}" && true
  exit_code=$?

  export LCOV_DEBUG="${orig_lcov_debug}"
  export PS4="${orig_ps4}"

  return "${exit_code}"
}

##
#
##
lcov_test_check() {
  local test="$1"
  local exit_code="$2"
  if [[ ${exit_code} -eq 0 ]]; then
    lcov_append_info "${lcov_test_log}" "${lcov_test_out}"
    local info=$(grep . "${lcov_test_out}" | tail -1)
    echo -e "${done_flag} ${test}: '${info}' (ok)";
    lcov_test_stat 1 1 0 0
  else
    local info="$(grep "." "${lcov_test_out}" | tail -1)"
    [[ -z "${info}" ]] && info="$(grep "." "${lcov_test_log}" | tail -1)"
    echo -e "${fail_flag} ${test}: '${info}' (exit ${exit_code})"
    lcov_test_stat 1 0 1 0
    if [[ -n "${stop_on_failure}" ]]; then
      cat "${lcov_test_out}"
      exit 1
    fi
  fi
}

##
# $1 - Log file
# $2 - Output file
##
lcov_append_info() {
  local line_stop="$(get_uuid)"
  local temp_info="${lcov_temp_dir}/temp.info"

  rm -f "${temp_info}"
  echo "${line_stop}" >> "$1"
  #echo "STOP" >> /home/francesco/Develop/Javanile/lcov.sh/a.txt
  #cat "$1" >> /home/francesco/Develop/Javanile/lcov.sh/a.txt
  while IFS= read -r line || [[ -n "${line}" ]]; do
    if [[ "${line::1}" = "+" ]]; then
      scope=$(echo ${line} | cut -s -d':' -f2)
      if [[ "${scope}" = "lcov.sh" ]]; then
        file="$(echo "${line}" | cut -s -d':' -f3)"
        file="$(readlink -f "${file}")"
        if [[ -n "$(grep -e "^${file}$" "${lcov_files}" && true)" ]]; then
          lineno=$(echo "${line}" | cut -s -d':' -f4)
          echo -e "TN:\nSF:${file}\nDA:${lineno},1\nend_of_record" >> "${temp_info}"
        fi
      fi
    elif [[ "${line}" = "${line_stop}" ]]; then
      lcov_exec -q -a "${temp_info}" -a "${lcov_info}" -o "${lcov_info}"
      rm -f "${temp_info}"
    fi
  done < "$1"
}

##
# Run function used inside BATS test case.
#
##
run() {
  log "BATS_RUN ${@}"
  #declare -p >> ${lcov_debug_log}

  local orig_ps4="${PS4}"
  local orig_lcov_debug="${LCOV_DEBUG}"
  local log_file="${lcov_temp_dir}/bats_${BATS_SUITE_TEST_NUMBER}_${BATS_TEST_NUMBER}.log"

  rm -f "${log_file}"

  export LCOV_DEBUG=1
  export PS4="${LCOV_PS4}"

  lcov_bats_run "${@}" 2>> "${log_file}"

  #log "BATS_OUTPUT=${output}"
  log "BATS_STATUS=${status}"

  export LCOV_DEBUG="${orig_lcov_debug}"
  export PS4="${orig_ps4}"
}

##
#
##
setup() {
  lcov_setup
}

##
#
##
lcov_setup() {
  if [[ -z "${LCOV_INIT}" ]]; then
    export LCOV_INIT=1
    lcov_init "${lcov_coverage[@]}"
  fi
}

##
# Run function used by BATS test case.
#
##
teardown() {
  lcov_teardown
}

##
#
##
lcov_teardown() {
  local log_file="${lcov_temp_dir}/bats_${BATS_SUITE_TEST_NUMBER}_${BATS_TEST_NUMBER}.log"
  log "BATS_TEARDOWN (${BATS_TEST_COMPLETED}) ${log_file}"
  if [[ "${BATS_TEST_COMPLETED}" = 1 ]]; then
    lcov_append_info "${log_file}"
  fi
  #rm "${log_file}"
  genhtml -q -o "${lcov_output}" "${lcov_info}"
}

##
# Execute testcase and prepare BATS global vars.
##
lcov_bats_run() {
  local flags="$-"
  set +eET
  local orig_ifs="$IFS"
  [[ "${flags}" =~ x ]] || set -x
  # shellcheck disable=SC2034
  output="$("$@")"
  # shellcheck disable=SC2034
  status="$?"
  [[ "${flags}" =~ x ]] || set +x
  # shellcheck disable=SC2034,SC2206
  IFS=$'\n' lines=($output)
  IFS="$orig_ifs"
  set "-$flags"
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
  options=$(${getopt} -n lcov.sh -o i:e:x:o:svh -l extension:,include:,exclude:,output:,stop-on-failure,version,help -- "$@")

  eval set -- "${options}"

  while true; do
    case "$1" in
      -o|--output) shift; lcov_output=$1 ;;
      -i|--include) shift; lcov_coverage+=("$1") ;;
      -x|--exclude) shift; lcov_coverage+=("!$1") ;;
      -e|--extension) shift; lcov_extension=$1 ;;
      -s|--stop-on-failure) shift; stop_on_failure=1 ;;
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

## Bypass entry-point if file was sourced
## than expose LCOV.SH and BATS functions
#if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
#  export -f run
#else
#  main "$@"
#  exit "$?"
#fi