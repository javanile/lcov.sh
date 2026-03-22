# Example: Case Statement Coverage

This example demonstrates how lcov.sh tracks **line coverage inside `case` statements**. Only two HTTP status codes and two log levels are tested — the rest show as uncovered.

> File: `script.sh`
```bash
#!/usr/bin/env bash

##
# Return the message for an HTTP status code.
##
http_status_message() {
    local code
    code="$1"

    case "$code" in
        200) echo "OK" ;;
        201) echo "Created" ;;
        301) echo "Moved Permanently" ;;
        400) echo "Bad Request" ;;
        401) echo "Unauthorized" ;;
        403) echo "Forbidden" ;;
        404) echo "Not Found" ;;
        500) echo "Internal Server Error" ;;
        503) echo "Service Unavailable" ;;
        *)   echo "Unknown status" ;;
    esac
}

##
# Convert a log level name to a numeric priority.
##
log_level_priority() {
    local level
    level="$1"

    case "$level" in
        trace) echo "0" ;;
        debug) echo "1" ;;
        info)  echo "2" ;;
        warn)  echo "3" ;;
        error) echo "4" ;;
        fatal) echo "5" ;;
        *)     echo "-1" ;;
    esac
}
```

> File: `test.sh`
```bash
#!/usr/bin/env bash
set -e

# shellcheck source=docs/examples/case_select/script.sh
source "$(dirname "${BASH_SOURCE[0]}")/script.sh"

# http_status_message: only testing 200 and 404
# NOT covered: 201, 301, 400, 401, 403, 500, 503, wildcard
http_status_message 200
http_status_message 404

# log_level_priority: only testing info and error
# NOT covered: trace, debug, warn, fatal, wildcard
log_level_priority info
log_level_priority error
```

```
$ lcov.sh -e xyz -o coverage -i script.sh test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  > grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
grep: /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/coverage/lcov.files: File o directory non esistente
DONE /home/francesco/Develop/Javanile/lcov.sh/docs/examples/case_select/test.sh: '4' (ok)
==> Error missing lcov_init before lcov_done.
    lcov_done() at /home/francesco/Develop/Javanile/lcov.sh/bin/lcov.sh:199
    main() at /home/francesco/Develop/Javanile/lcov.sh/bin/lcov.sh:685
    main() at /home/francesco/Develop/Javanile/lcov.sh/bin/lcov.sh:0
```

> Each untested `case` branch appears red — helping you identify missing test scenarios.

<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>
