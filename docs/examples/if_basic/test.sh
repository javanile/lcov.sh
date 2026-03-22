#!/usr/bin/env bash
set -e

# shellcheck source=docs/examples/if_basic/script.sh
source "$(dirname "${BASH_SOURCE[0]}")/script.sh"

# classify_number: positive and zero only — negative NOT covered
classify_number 5
classify_number 0

# describe_temperature: hot and cold only — warm and cool NOT covered
describe_temperature 35
describe_temperature 5

# validate_age: adult and invalid string only — minor, senior, too-large NOT covered
validate_age 30
validate_age "abc" || true

# check_sign: positive only — negative and zero NOT covered
check_sign 10
