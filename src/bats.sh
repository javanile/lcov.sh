
##
# Run function used inside BATS test case.
##
run() {
  log "BATS_RUN ${@}"

  local orig_ps4
  local orig_lcov_debug
  local log_file
  orig_ps4="${PS4}"
  orig_lcov_debug="${LCOV_DEBUG}"
  log_file="${lcov_temp_dir}/bats_${BATS_SUITE_TEST_NUMBER}_${BATS_TEST_NUMBER}.log"

  rm -f "${log_file}"

  export LCOV_DEBUG=1
  export PS4="${LCOV_PS4}"

  lcov_bats_run "${@}" 2>> "${log_file}"

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
##
teardown() {
  lcov_teardown
}

##
#
##
lcov_teardown() {
  local log_file
  log_file="${lcov_temp_dir}/bats_${BATS_SUITE_TEST_NUMBER}_${BATS_TEST_NUMBER}.log"
  log "BATS_TEARDOWN (${BATS_TEST_COMPLETED}) ${log_file}"
  if [[ "${BATS_TEST_COMPLETED}" = 1 ]]; then
    lcov_append_info "${log_file}"
  fi
  genhtml -q -o "${lcov_output}" "${lcov_info}"
}

##
# Execute testcase and prepare BATS global vars.
##
lcov_bats_run() {
  local flags
  flags="$-"
  set +eET
  local orig_ifs
  orig_ifs="$IFS"
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