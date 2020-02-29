#!/usr/bin/env bash

##
# LCOV.SH
#
# The best LCOV framework around BASH projects.
#
# Copyright (c) 2019 Francesco Bianco <bianco@javanile.org>
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

[[ -z "${LCOV_DEBUG}" ]] || set -x

set -f

VERSION="0.13.4"

trap '$(jobs -p) || kill $(jobs -p)' EXIT

export LCOV_DEBUG=1
export PS4='+:${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

case "$(uname -s)" in
    Darwin*)
        getopt=/usr/local/opt/gnu-getopt/bin/getopt
        fail_flag='\x1B[1m\x1B[31m(fail)\x1B[0m'
        done_flag='\x1B[1m\x1B[32m(done)\x1B[0m'
        skip_flag='\x1B[37m(skip)\x1B[0m'
        ;;
    Linux|*)
        getopt=/usr/local/bin/getopt
        fail_flag="\e[1m\e[31m(fail)\e[0m"
        done_flag="\e[1m\e[32m(done)\e[0m"
        skip_flag="\e[37m(skip)\e[0m"
        ;;
esac

options=$(${getopt} -n lcov.sh -o o:v -l output:,version -- "$@")
output=coverage

eval set -- "${options}"

while true; do
    case "$1" in
        -o|--output) shift; output=$1 ;;
        -v|--version) echo "LCOV.SH version ${VERSION}"; exit ;;
        -h|--help) usage; exit ;;
        --) shift; break ;;
    esac
    shift
done

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
        uuidgen
    fi
}

##
#
#
# Arguments
#  - $1...$N: include or exclude glob or path (eg: *.sh, !test, etc...)
# Outputs
#  - Create output directory with scanned tracefile lcov.info file.
##
get_files () {
    include="-name *.sh"
    exclude="-not -name .gitignore -not -path .git"

    for arg in "$@"; do
        if [[ "${arg::1}" != "!" ]]; then
            include+=" -or -wholename ${arg}"
        else
            exclude+=" -not -wholename ${arg:1} -not -path *${arg:1}*"
        fi
    done

    find . -type f \( ${include[0]} \) \( ${exclude[0]} \)
}

##
# Initialize output directory.
#
# Arguments
#  - $1...$N: include or exclude glob or path (eg: *.sh, !test, etc...)
# Outputs
#  - Create output directory with scanned tracefile lcov.info file.
##
lcov_init () {
    echo -e "LCOV.SH by Francesco Bianco <bianco@javanile.org>\n"

    mkdir -p "${output}"
    rm -f "${output}/lcov.info" "${output}/test.*"

    get_files "$@" | while read file; do
        lcov_scan "${file}" > "${output}/init.info"
        [[ -f "${output}/lcov.info" ]] || lcov -q -a "${output}/init.info" -o "${output}/lcov.info" && true
        lcov -q -a "${output}/init.info" -a "${output}/lcov.info" -o "${output}/lcov.info" >/dev/null 2>&1 && true
        rm -f "${output}/init.info"
    done
}

##
#
#
##
lcov_scan () {
    lineno=0
    skip_eof=
    echo "TN:"
    echo "SF:$1"
    while IFS= read line || [[ -n "${line}" ]]; do
        line=${line%%*( )}
        lineno=$((lineno + 1))
        [[ -z "${line}" ]] && continue
        [[ "${line}" == "fi" ]] && continue
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
}

##
# Print-out summary of tests.
#
# Arguments:
#  - no args
# Outputs:
#  - Show LCOV summary with tests information
##
lcov_done () {
    echo ""
    stat="0 0 0 0"
    [[ -f "${output}/test.stat" ]] && stat="$(cat ${output}/test.stat && true)"
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
    genhtml -q -o "${output}" "${output}/lcov.info"
    lcov --summary "${output}/lcov.info"
    echo -e "  tests......: ${test} (${done} done, ${fail} fail, ${skip} skip)"
    echo -e "  exit.......: ${exit_code} ${exit_info}"
    exit ${exit_code}
}

##
#
##
run_wait () {
    while [[ -f ${output}/test.lock ]]; do sleep 2; done;
    touch ${output}/test.lock
    return 0
}

##
#
##
run_step () {
    rm -f ${output}/test.lock
    return 0
}

##
#
##
run_stat () {
    stat="0 "
    [[ -f "${output}/test.stat" ]] && stat+="$(cat "${output}/test.stat")"
    test=$(expr $(echo ${stat} | cut -d' ' -f2) + $1 || true)
    done=$(expr $(echo ${stat} | cut -d' ' -f3) + $2 || true)
    fail=$(expr $(echo ${stat} | cut -d' ' -f4) + $3 || true)
    skip=$(expr $(echo ${stat} | cut -d' ' -f5) + $4 || true)
    echo "${test} ${done} ${fail} ${skip}" > "${output}/test.stat"
    return 0
}

##
#
##
run_test () {
    if [[ ! -z $1 ]]; then
        run_wait
        echo -n "  > "
        if [[ -f $1 ]]; then
            rm -f ${output}/test.info
            bash -x $1 >${output}/test.out 2>${output}/test.log && true
            exit_code=$?
            if [[ ${exit_code} -eq 0 ]]; then
                lcov_stop=get_uuid
                echo "${lcov_stop}" >> ${output}/test.log
                while IFS= read line || [[ -n "${line}" ]]; do
                    if [[ "${line::1}" == "+" ]]; then
                        file=$(echo ${line} | cut -s -d':' -f2)
                        lineno=$(echo ${line} | cut -s -d':' -f3)
                        echo -e "TN:\nSF:${file}\nDA:${lineno},1\nend_of_record" >> ${output}/test.info
                    elif [[ "${line}" == "${lcov_stop}" ]]; then
                        info=$(grep . ${output}/test.out | tail -1)
                        echo -e "${done_flag} $1: '${info}' (ok)";
                        lcov -q -a ${output}/test.info -a ${output}/lcov.info -o ${output}/lcov.info && true
                        shift; run_stat 1 1 0 0; run_step; run_test "$@"
                    fi
                done < "${output}/test.log"
            else
                info="$(grep "." "${output}/test.out" | tail -1)"
                echo -e "${fail_flag} $1: '${info}' (exit ${exit_code})"
                shift; run_stat 1 0 1 0; run_step; run_test "$@"
            fi
        else
            echo -e "${skip_flag} $1: file not found.";
            shift; run_stat 1 0 0 1; run_step; run_test "$@"
        fi
    fi
    return 0
}

##
#
##
main () {
    lcov_init ./*.sh !test.sh !release.sh !coverage
    run_test "$@"
    lcov_done
}

##
#
##
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    main "$@"
fi