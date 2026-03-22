---
title: "Example: If / Elif / Else Coverage"
---

This example shows multi-line `if/elif/else` chains alongside **one-liner `if` statements** and short-circuit `&&` guards. The test only exercises a subset of paths — uncovered branches appear red.

**`script.sh`**

```bash
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
```

**`test.sh`**

```bash
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
```

```text
$ lcov.sh -e xyz -o coverage -i script.sh test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  DONE test.sh: 'positive' (ok)

Overall coverage rate:
  lines......: 82.8% (24 of 29 lines)
  functions..: no data found
Summary coverage rate:
  lines......: 82.8% (24 of 29 lines)
  functions..: no data found
  branches...: no data found
  tests......: 1 (1 done, 0 fail, 0 skip)
  exit.......: 0 DONE
```

_The red lines below are branches that were **never executed** by the test._

<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>
