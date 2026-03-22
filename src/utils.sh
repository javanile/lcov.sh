
##
# Generate UUID.
#
# Arguments
#  - None
# Outputs
#  - UUID random code
##
get_uuid() {
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
get_files() {
  local include
  local exclude
  include="-name *.${lcov_extension}"
  exclude="-not -wholename ${lcov_output} -not -path .git"

  for arg in "$@"; do
    if [[ "${arg::1}" != "!" ]]; then
      [[ "${arg::1}" != "/" && "${arg::2}" != "./" ]] && arg="./${arg}"
      include+=" -or -wholename ${arg}"
    else
      exclude+=" -not -wholename ${arg:1} -not -path *${arg:1}*"
    fi
  done

  find . -type f \( ${include[0]} \) \( ${exclude[0]} \)

  return 0
}

##
# Show a text spinner on the current line while a background process runs.
# Usage: lcov_spinner_start <message>  → sets lcov_spinner_pid
#        lcov_spinner_stop             → kills spinner and clears line
##
lcov_spinner_start() {
  local msg="${1:-scanning...}"
  local frames=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
  local i=0
  [[ -t 1 ]] || return 0
  (
    while true; do
      printf "\r  > %s %s" "${frames[$((i % 8))]}" "${msg}"
      i=$((i + 1))
      sleep 0.08
    done
  ) &
  lcov_spinner_pid=$!
}

lcov_spinner_stop() {
  [[ -z "${lcov_spinner_pid:-}" ]] && return 0
  kill "${lcov_spinner_pid}" 2>/dev/null
  wait "${lcov_spinner_pid}" 2>/dev/null || true
  printf "\r%-60s\r" ""
  lcov_spinner_pid=
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
  local stack_size
  stack_size=${#FUNCNAME[@]}
  for (( i=1; i<stack_size; i++ )); do
    local func
    local linen
    local src
    func="${FUNCNAME[$i]}"
    [ x"$func" = x ] && func=MAIN
    linen="${BASH_LINENO[$i]}"
    src="${BASH_SOURCE[$i]}"
    [ x"$src" = x ] && src=non_file_source
    echo "    ${func}() at ${src}:${linen}"
  done
}