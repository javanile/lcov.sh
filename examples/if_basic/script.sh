#!/usr/bin/env bash

##
# Classify a number as positive, negative or zero.
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
# Describe a temperature range.
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
