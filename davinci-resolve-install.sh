#!/bin/bash
#
# Assists with installing DaVinci Resolve.
# NOTE: Needs to be run as root since it needs access
# to /opt, and make sure libxcrypt-compat is installed.

set -euo pipefail

# validate parameters
if (( $# -ne 1 )); then
    echo 'invalid parameters'
    echo 'usage: ./davinci-resolve-install.sh [SRC]'
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo 'no source file found'
    exit 1
fi

# run the installer and clean up broken libraries
SKIP_PACKAGE_CHECK=1 "$1" -i
rm                                   \
    '/opt/resolve/libs/libgio-'*     \
    '/opt/resolve/libs/libglib-'*    \
    '/opt/resolve/libs/libgmodule-'* \
    '/opt/resolve/libs/libgobject-'*
