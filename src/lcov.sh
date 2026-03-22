
##
#
##
lcov_exec() {
  local log
  log=$(lcov "${@}" 2>&1) || true
  if [[ -n ${log} ]]; then
    error "${log}" >> "${lcov_log}"
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

  local init_info
  init_info="${lcov_output}/init.info"

  get_files "$@" | while IFS= read -r file; do
    local abs_file
    abs_file="$(readlink -f "${file}")"
    echo "${abs_file}" >> "${lcov_files}"
    lcov_scan "${abs_file}" > "${init_info}"
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
  local lineno
  local skip_eof
  lineno=0
  skip_eof=

  echo "TN:"
  echo "SF:$1"

  while IFS= read line || [[ -n "${line}" ]]; do
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
    local hit=0
    [[ "${line}" == *'[ -z "${LCOV_DEBUG}" ] || set -x'* ]] && hit=1
    echo "DA:${lineno},${hit}"
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
    local stat
    local test
    local done
    local fail
    local skip
    local exit_info
    local exit_code
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
# $1 - Log file
# $2 - Output file
##
lcov_append_info() {
  local line_stop
  local temp_info
  line_stop="$(get_uuid)"
  temp_info="${lcov_temp_dir}/temp.info"

  rm -f "${temp_info}"
  echo "${line_stop}" >> "$1"
  while IFS= read -r line || [[ -n "${line}" ]]; do
    if [[ "${line::1}" = "+" ]]; then
      local scope
      local file
      local lineno
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