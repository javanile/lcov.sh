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
