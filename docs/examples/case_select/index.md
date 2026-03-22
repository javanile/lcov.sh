---
title: "Example: Case Statement Coverage"
---

This example mixes **one-liner `case` branches** (`200) echo "OK" ;;`) with **multi-line branches** and pipe alternatives (`PUT|PATCH`). Only a subset of branches are tested — the rest show as uncovered.

**`script.sh`**

```bash
#!/usr/bin/env bash

[ -z "${LCOV_DEBUG}" ] || set -x

##
# Return the message for an HTTP status code.
# Uses one-liner case branches.
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
# Describe an HTTP method using multi-line case branches.
# Also shows a pipe-alternative pattern (PUT|PATCH).
##
http_method_info() {
    local method
    method="$1"

    case "$method" in
        GET)
            echo "read-only"
            echo "safe and idempotent"
            ;;
        POST)
            echo "creates resource"
            ;;
        PUT|PATCH)
            echo "updates resource"
            ;;
        DELETE)
            echo "removes resource"
            ;;
        *)
            echo "unknown method"
            ;;
    esac
}

##
# Convert a log level name to a numeric priority.
# Uses one-liner case branches.
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

**`test.sh`**

```bash
#!/usr/bin/env bash
set -e

# shellcheck source=docs/examples/case_select/script.sh
source "$(dirname "${BASH_SOURCE[0]}")/script.sh"

# http_status_message: 200, 404, 500 only — 201, 301, 400, 401, 403, 503 NOT covered
http_status_message 200
http_status_message 404
http_status_message 500

# http_method_info: GET and DELETE only — POST, PUT/PATCH NOT covered
http_method_info GET
http_method_info DELETE

# log_level_priority: info and error only — trace, debug, warn, fatal NOT covered
log_level_priority info
log_level_priority error
```

```text
$ lcov.sh -e xyz -o coverage -i script.sh test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  DONE test.sh: '4' (ok)

Overall coverage rate:
  lines......: 52.6% (20 of 38 lines)
  functions..: no data found
Summary coverage rate:
  lines......: 52.6% (20 of 38 lines)
  functions..: no data found
  branches...: no data found
  tests......: 1 (1 done, 0 fail, 0 skip)
  exit.......: 0 DONE
```

_Each untested `case` branch appears red — helping you identify missing test scenarios._

<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>
