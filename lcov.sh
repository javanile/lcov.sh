#!/bin/bash
set -f
[[ -z "${LCOV_DEBUG}" ]] || set -x

trap '$(jobs -p) || kill $(jobs -p)' EXIT

export LCOV_DEBUG=1

### http://www.skybert.net/bash/debugging-bash-scripts-on-the-command-line/
export PS4='+:${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
lcov_stop=$(cat /proc/sys/kernel/random/uuid)
options=$(getopt -n lcov.sh -o o: -l output: -- "$@")
output=coverage

eval set -- "${options}"

while true; do
    case "$1" in
        -o|--output) shift; output=$1 ;;
        -h|--help) usage; exit ;;
        --) shift; break ;;
    esac
    shift
done

##
##
##
lcov_init () {
    echo -e "LCOV.SH by Francesco Bianco <bianco@javanile.org>\n"

    mkdir -p "${output}"
    include="-name lcov.sh"
    exclude="-not -name .gitignore -not -path .git"

    for arg in "$@"; do
        if [[ "${arg::1}" != "!" ]]; then
            include+=" -or -name ${arg}"
        else
            exclude+=" -not -name ${arg:1} -not -path *${arg:1}*"
        fi
    done

    rm -f ${output}/test.stat ${output}/test.lock ${output}/lcov.info >/dev/null 2>&1
    find . -type f \( ${include[0]} \) \( ${exclude[0]} \) | while read file; do
        lcov_scan "${file}" > "${output}/init.info"
        [[ -f "${output}/lcov.info" ]] || lcov -q -a "${output}/init.info" -o "${output}/lcov.info" && true
        lcov -q -a "${output}/init.info" -a "${output}/lcov.info" -o "${output}/lcov.info" >/dev/null 2>&1 && true
    done
}

##
##
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
##
##
lcov_done () {
    echo ""
    stat="0 0 0 0"
    [[ -f ${output}/test.stat ]] && stat=$(cat ${output}/test.stat && true)
    test=$(echo ${stat} | cut -s -d' ' -f1)
    done=$(echo ${stat} | cut -s -d' ' -f2)
    fail=$(echo ${stat} | cut -s -d' ' -f3)
    skip=$(echo ${stat} | cut -s -d' ' -f4)
    if [[ "${fail}" -gt "0" ]]; then
        exit_info=fail
        exit_code=1
    else
        exit_info=success
        exit_code=0
    fi
    genhtml -q -o "${output}" "${output}/lcov.info"
    lcov --summary "${output}/lcov.info"
    echo "  tests......: ${test} (${done} done, ${fail} fail, ${skip} skip)"
    echo "  exit.......: ${exit_code} (${exit_info})"
    exit ${exit}
}

##
##
##
run_wait () {
    while [[ -f ${output}/test.lock ]]; do sleep 2; done;
    touch ${output}/test.lock
    return 0
}

##
##
##
run_step () {
    rm -f ${output}/test.lock
    return 0
}

##
##
##
run_stat () {
    stat="0 "
    [[ -f ${output}/test.stat ]] && stat+=$(cat ${output}/test.stat)
    test=$(expr $(echo ${stat} | cut -d' ' -f2) + $1 || true)
    done=$(expr $(echo ${stat} | cut -d' ' -f3) + $2 || true)
    fail=$(expr $(echo ${stat} | cut -d' ' -f4) + $3 || true)
    skip=$(expr $(echo ${stat} | cut -d' ' -f5) + $4 || true)
    echo "${test} ${done} ${fail} ${skip}" > ${output}/test.stat
    return 0
}

##
##
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
                echo "${lcov_stop}" >> ${output}/test.log
                while IFS= read line || [[ -n "${line}" ]]; do
                    if [[ "${line::1}" == "+" ]]; then
                        file=$(echo ${line} | cut -s -d':' -f2)
                        lineno=$(echo ${line} | cut -s -d':' -f3)
                        echo -e "TN:\nSF:${file}\nDA:${lineno},1\nend_of_record" >> ${output}/test.info
                    elif [[ "${line}" == "${lcov_stop}" ]]; then
                        info=$(grep . ${output}/test.out | tail -1)
                        echo "[done] $1: '${info}' (ok)";
                        lcov -q -a ${output}/test.info -a ${output}/lcov.info -o ${output}/lcov.info && true
                        shift; run_stat 1 1 0 0; run_step; run_test "$@"
                    fi
                done < "${output}/test.log"
            else
                info=$(grep "." ${output}/test.out | tail -1)
                echo "[fail] $1: '${info}' (exit ${exit_code})";
                shift; run_stat 1 0 1 0; run_step; run_test "$@"
            fi
        else
            echo "[skip] $1: file not found.";
            shift; run_stat 1 0 0 1; run_step; run_test "$@"
        fi
    fi
    return 0
}
