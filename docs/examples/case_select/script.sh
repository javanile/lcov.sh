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
