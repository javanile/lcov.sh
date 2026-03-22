#!/usr/bin/env bash
set -e

# shellcheck source=docs/examples/mixed/script.sh
source "$(dirname "${BASH_SOURCE[0]}")/script.sh"

# authenticate: admin login and missing username — guest and wrong credentials NOT covered
authenticate "admin" "secret"
authenticate "" "pass" || true

# normalize_text: with content — empty string NOT covered
normalize_text "  Hello   World  "

# deploy: staging only — prod brace block and unknown env NOT covered
deploy staging

# check_access: viewer read (granted) and viewer write (denied)
check_access viewer read
check_access viewer write || true
