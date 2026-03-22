#!/usr/bin/env bash
set -e

# shellcheck source=docs/examples/mixed/script.sh
source "$(dirname "${BASH_SOURCE[0]}")/script.sh"

# authenticate: only testing successful admin login
# NOT covered: empty username, empty password, guest login, wrong credentials
authenticate "admin" "secret"

# get_permissions: only testing admin and viewer
# NOT covered: superadmin, editor, wildcard
get_permissions "admin"
get_permissions "viewer"

# check_access: only testing read access for viewer
# NOT covered: denied access path
check_access "viewer" "read"
