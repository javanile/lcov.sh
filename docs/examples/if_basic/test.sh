#!/usr/bin/env bash
set -e

# shellcheck source=docs/examples/if_basic/script.sh
source "$(dirname "${BASH_SOURCE[0]}")/script.sh"

# classify_number: only testing POSITIVE — negative and zero branches NOT covered
classify_number 5
classify_number 42

# describe_temperature: only testing HOT — warm, cool, cold branches NOT covered
describe_temperature 35
describe_temperature 40
