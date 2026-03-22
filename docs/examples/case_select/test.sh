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
