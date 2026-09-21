#!/bin/bash
#
# Globally installs the Odin programming language from a
# specified Odin tar, replacing any previous installation.
# NOTE: Needs to be run as root since it needs access to /opt, /usr and /etc.

set -euo pipefail

readonly LINK_DIR='/usr/local/bin'
readonly INSTALL_DIR='/opt/odin'
readonly CONFIG_DIR='/etc/environment.d'

# validate parameters
if (( $# -ne 1 )); then
    echo 'invalid parameters'
    echo 'usage: ./odin-update.sh [SRC]'
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo 'no source file found'
    exit 1
fi

# make the installation directory if it doesn't already exist
if [[ ! -d "${INSTALL_DIR}" ]]; then
    mkdir "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

# remove any previous installation and install the new one
rm -rf *
tar -xf "$1" --strip-components 1

# add a symlink to the binary in /usr/local/bin if one doesn't already exist
if [[ ! -f "${LINK_DIR}/odin" ]]; then
    ln -s "${INSTALL_DIR}/odin" "${LINK_DIR}"
fi

# add an environment config if one doesn't already exist
if [[ ! -f "${CONFIG_DIR}/odin.conf" ]]; then
    if [[ ! -d "${CONFIG_DIR}" ]]; then
        mkdir "${CONFIG_DIR}"
    fi

    echo "ODIN_ROOT=${INSTALL_DIR}" > "${CONFIG_DIR}/odin.conf"
fi
