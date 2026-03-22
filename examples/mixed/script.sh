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
