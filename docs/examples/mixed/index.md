---
title: "Example: Mixed Patterns Coverage"
---

This example combines one-liner `if` guards, multi-line `case` branches, a **pipe chain with escaped newlines** (`\\`), and a **brace group block** (`{ ... }`). Only some paths are tested.

**`script.sh`**

```bash
#!/usr/bin/env bash

[ -z "${LCOV_DEBUG}" ] || set -x

##
# Authenticate a user — uses one-liner if guards at the top.
##
authenticate() {
    local username
    local password
    username="$1"
    password="$2"

    if [[ -z "$username" ]]; then echo "error: username required"; return 1; fi
    if [[ -z "$password" ]]; then echo "error: password required"; return 1; fi

    if [[ "$username" == "admin" && "$password" == "secret" ]]; then
        echo "authenticated as admin"
        return 0
    elif [[ "$username" == "guest" ]]; then
        echo "authenticated as guest"
        return 0
    else
        echo "authentication failed"
        return 1
    fi
}

##
# Return the permissions for a given role — mix of multi-line case branches.
##
get_permissions() {
    local role
    role="$1"

    case "$role" in
        superadmin)
            echo "read write delete manage"
            ;;
        admin)
            echo "read write delete"
            ;;
        editor)
            echo "read write"
            ;;
        viewer)
            echo "read"
            ;;
        *)
            echo "none"
            ;;
    esac
}

##
# Normalize a text string using a pipe chain with escaped newlines.
##
normalize_text() {
    local text
    text="$1"

    if [[ -z "$text" ]]; then
        echo "empty"
        return 1
    fi

    echo "$text" \
        | tr '[:upper:]' '[:lower:]' \
        | tr -s ' ' \
        | sed 's/^ //;s/ $//'
}

##
# Run a deploy sequence using a brace group block.
##
deploy() {
    local env
    env="$1"

    if [[ "$env" == "prod" ]]; then
        {
            echo "stopping services"
            echo "running migrations"
            echo "starting services"
        }
        return 0
    elif [[ "$env" == "staging" ]]; then
        echo "deploying to staging"
        return 0
    else
        echo "unknown environment: $env"
        return 1
    fi
}

##
# Check if a user has access to an action based on their role.
##
check_access() {
    local role
    local action
    role="$1"
    action="$2"

    local perms
    perms="$(get_permissions "$role")"

    if [[ "$perms" == *"$action"* ]]; then
        echo "access granted: $role can $action"
        return 0
    else
        echo "access denied: $role cannot $action"
        return 1
    fi
}
```

**`test.sh`**

```bash
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
```

```text
$ lcov.sh -e xyz -o coverage -i script.sh test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  DONE test.sh: 'access denied: viewer cannot write' (ok)

Overall coverage rate:
  lines......: 59.1% (39 of 66 lines)
  functions..: no data found
Summary coverage rate:
  lines......: 59.1% (39 of 66 lines)
  functions..: no data found
  branches...: no data found
  tests......: 1 (1 done, 0 fail, 0 skip)
  exit.......: 0 DONE
```

_The coverage report highlights which error paths, pipe stages, brace blocks, and access denials were never tested._

<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>
