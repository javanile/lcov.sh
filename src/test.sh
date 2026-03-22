
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
  rm -f "${lcov_output}/test.lock"
  return 0
}

##
# Store running tests stat.
##
lcov_test_stat() {
  local stat
  stat="0 "
  [[ -f "${lcov_test_stat}" ]] && stat+="$(cat "${lcov_test_stat}")"

  local test
  local done
  local fail
  local skip
  test=$(expr $(echo ${stat} | cut -d' ' -f2) + $1 || true)
  done=$(expr $(echo ${stat} | cut -d' ' -f3) + $2 || true)
  fail=$(expr $(echo ${stat} | cut -d' ' -f4) + $3 || true)
  skip=$(expr $(echo ${stat} | cut -d' ' -f5) + $4 || true)

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
        echo -e "${skip_flag} $1/: is directory."
      else
        echo -e "${skip_flag} $1: file not found."
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
##
lcov_test_debug() {
  local orig_ps4
  local orig_lcov_debug
  local exit_code
  orig_ps4="${PS4}"
  orig_lcov_debug="${LCOV_DEBUG}"

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
  local test
  local exit_code
  test="$1"
  exit_code="$2"
  if [[ ${exit_code} -eq 0 ]]; then
    lcov_append_info "${lcov_test_log}" "${lcov_test_out}"
    local info
    info=$(grep . "${lcov_test_out}" | tail -1)
    echo -e "${done_flag} ${test}: '${info}' (ok)"
    lcov_test_stat 1 1 0 0
  else
    local info
    info="$(grep "." "${lcov_test_out}" | tail -1)"
    [[ -z "${info}" ]] && info="$(grep "." "${lcov_test_log}" | tail -1)"
    echo -e "${fail_flag} ${test}: '${info}' (exit ${exit_code})"
    lcov_test_stat 1 0 1 0
    if [[ -n "${stop_on_failure}" ]]; then
      cat "${lcov_test_out}"
      exit 1
    fi
  fi
}