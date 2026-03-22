# Example: If / Elif / Else Coverage

This example demonstrates how lcov.sh tracks **line coverage inside `if`, `elif`, and `else` branches**. The test only exercises a subset of paths — uncovered branches are highlighted in the report.

> File: `script.sh`
```bash
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
```

> File: `test.sh`
```bash
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
```

```
$ lcov.sh -e xyz -o coverage -i script.sh test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  > grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/coverage/lcov.files: File o directory non esistente
DONE /home/francesco/Develop/Javanile/lcov.sh/docs/examples/if_basic/test.sh: 'hot' (ok)
==> Error missing lcov_init before lcov_done.
    lcov_done() at /home/francesco/Develop/Javanile/lcov.sh/bin/lcov.sh:199
    main() at /home/francesco/Develop/Javanile/lcov.sh/bin/lcov.sh:685
    main() at /home/francesco/Develop/Javanile/lcov.sh/bin/lcov.sh:0
```

> The red lines below are branches that were **never executed** by the test.

<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>
