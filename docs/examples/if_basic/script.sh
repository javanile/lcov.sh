#!/usr/bin/env bash

[ -z "${LCOV_DEBUG}" ] || set -x

##
# Classify a number using a standard multi-line if/elif/else.
##
classify_number() {
    local n
    n="$1"

    if [[ "$n" -gt 0 ]]; then
        echo "positive"
    elif [[ "$n" -lt 0 ]]; then
        echo "negative"
    else
        echo "zero"
    fi
}

##
# Describe a temperature range (multi-line if/elif chain).
##
describe_temperature() {
    local temp
    temp="$1"

    if [[ "$temp" -ge 30 ]]; then
        echo "hot"
    elif [[ "$temp" -ge 20 ]]; then
        echo "warm"
    elif [[ "$temp" -ge 10 ]]; then
        echo "cool"
    else
        echo "cold"
    fi
}

##
# Validate an age using one-liner if statements (each on its own line).
##
validate_age() {
    local age
    age="$1"

    if [[ ! "$age" =~ ^[0-9]+$ ]]; then echo "invalid: not a number"; return 1; fi
    if [[ "$age" -gt 150 ]]; then echo "invalid: too large"; return 1; fi
    if [[ "$age" -lt 18 ]]; then echo "minor"; return 0; fi
    if [[ "$age" -ge 65 ]]; then echo "senior"; return 0; fi
    echo "adult"
}

##
# Check the sign of a number using short-circuit && operators on one line.
##
check_sign() {
    local n
    n="$1"

    [[ "$n" -gt 0 ]] && echo "positive" && return 0
    [[ "$n" -lt 0 ]] && echo "negative" && return 0
    echo "zero"
}
