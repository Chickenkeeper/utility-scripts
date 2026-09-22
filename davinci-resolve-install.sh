#!/bin/bash
#
# Assists with installing DaVinci Resolve.
# NOTE: Needs to be run as root since it needs access
# to /opt, and make sure libxcrypt-compat is installed.

set -euo pipefail

show_help() {
    cat << END
# Assists with installing DaVinci Resolve from its installer (SRC).
# NOTE: Needs to be run as root since it needs access to /opt,
# and make sure libxcrypt-compat is installed.

Usages:
    ${0##*/} [SRC]
    ${0##*/} [OPTION]

Options:
    -h, --help  show this help message and exit.
END
}

error() {
    echo "Error: ${1}. Usage: ${0##*/} [SRC] (or -h/--help for help)" >&2
    exit 1
}

paths=()

# parse arguments
while (( $# > 0 )); do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        --)
            shift
            paths+=("$@") # include paths which start with a dash
            break
            ;;
        -*)
            error "unknown option \"${1}\""
            ;;
        *)
            paths+=("$1")
            shift
            ;;
    esac
done

# validate paths
if [[ ${#paths[@]} -ne 1 ]]; then
    error 'invalid arguments'
elif [[ ! -f ${paths[0]} ]]; then
    error 'invalid source'
fi

readonly SRC_FILE="${paths[0]}"

# run the installer and clean up broken libraries
echo 'Running DaVinci Resolve installer...'
SKIP_PACKAGE_CHECK=1 "${SRC_FILE}" -i
echo 'Cleaning up libraries...'
rm                                   \
    '/opt/resolve/libs/libgio-'*     \
    '/opt/resolve/libs/libglib-'*    \
    '/opt/resolve/libs/libgmodule-'* \
    '/opt/resolve/libs/libgobject-'*
echo 'Success'
