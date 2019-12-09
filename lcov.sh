#!/bin/bash
set -f
[[ -z "${LCOV_DEBUG}" ]] || set -x

export LCOV_DEBUG=1
export PS4='+:$0:$LINENO: '
lcov_stop=$(cat /proc/sys/kernel/random/uuid)
trap '$(jobs -p) || kill $(jobs -p)' EXIT

lcov_init () {
    mkdir -p coverage
    include="-name lcov.sh"
    exclude="-not -name .gitignore -not -path .git"

    for arg in "$@"; do
        if [[ "${arg::1}" != "!" ]]; then
            include+=" -or -name ${arg}"
        else
            exclude+=" -not -name ${arg:1} -not -path *${arg:1}*"
        fi
    done

    rm -f coverage/lcov.info >/dev/null 2>&1
    find . -type f \( ${include[0]} \) ${exclude[0]} | while read file; do
        lcov_scan ${file} > coverage/init.info
        [[ -f coverage/lcov.info ]] || lcov -q -a coverage/init.info -o coverage/lcov.info
        lcov -q -a coverage/init.info -a coverage/lcov.info -o coverage/lcov.info >/dev/null 2>&1 && true
    done
}

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
    done < $1
    echo "end_of_record"
}

lcov_done () {
    genhtml -q -o coverage coverage/lcov.info
}

run_test () {
    for test in "$@"; do
        [[ -f ${test} ]] || continue
        rm -f coverage/test.info
        bash -x ${test} 2> coverage/test.log
        echo "${lcov_stop}" >> coverage/test.log
        while IFS= read line || [[ -n "${line}" ]]; do
            #echo "${line}"
            if [[ "${line::1}" == "+" ]]; then
                file=$(echo ${line} | cut -s -d':' -f2)
                lineno=$(echo ${line} | cut -s -d':' -f3)
                echo -e "TN:\nSF:${file}\nDA:${lineno},1\nend_of_record" >> coverage/test.info
            elif [[ "${line}" == "${lcov_stop}" ]]; then
                lcov -q -a coverage/test.info -a coverage/lcov.info -o coverage/lcov.info
            fi
        done < coverage/test.log
    done
}
