#!/usr/bin/env bash
set -e

# shellcheck disable=SC1091
source ./tests/pipetest.sh
# shellcheck source=./bin/lcov.sh
source ./bin/lcov.sh
lcov_env tests/coverage

# With no debug log set, log should produce no output
log "this message should not appear"
echo "ok" | assert_equals "ok"

# With debug log set, message should be written to the log file
tmp_log=$(mktemp)
lcov_debug_log="${tmp_log}"
log "hello from log"
grep -c "hello from log" "${tmp_log}" | assert_equals 1
rm -f "${tmp_log}"
