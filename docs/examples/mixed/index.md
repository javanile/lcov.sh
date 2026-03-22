---
title: "Example: Mixed If + Case Coverage"
---

This example combines **nested `if` guards and a `case` dispatch** to show how lcov.sh handles real-world scripts where multiple code paths exist simultaneously.

**`script.sh`**

```bash
#!/usr/bin/env bash

##
# Authenticate a user with username and password.
# Returns 0 on success, 1 on failure.
##
authenticate() {
    local username
    local password
    username="$1"
    password="$2"

    if [[ -z "$username" ]]; then
        echo "error: username required"
        return 1
    fi

    if [[ -z "$password" ]]; then
        echo "error: password required"
        return 1
    fi

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
# Return the permissions for a given role.
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
```

```text
$ lcov.sh -e xyz -o coverage -i script.sh test.sh
LCOV.SH by Francesco Bianco <bianco@javanile.org>

  DONE test.sh: 'access granted: viewer can read' (ok)

Overall coverage rate:
  lines......: 59.5% (25 of 42 lines)
  functions..: no data found
Summary coverage rate:
  lines......: 59.5% (25 of 42 lines)
  functions..: no data found
  branches...: no data found
  tests......: 1 (1 done, 0 fail, 0 skip)
  exit.......: 0 DONE
```

_The coverage report shows exactly which error paths, roles, and access denials were never tested._

<iframe width="100%" height="640" src="coverage/index.html" frameborder="0" scrolling="yes" style="border:1px solid #ddd;border-radius:4px"></iframe>
