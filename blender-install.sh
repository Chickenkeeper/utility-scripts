#!/bin/bash
#
# Locally installs Blender from a specified
# Blender tar, replacing any previous installation.

set -euo pipefail

readonly INSTALL_DIR="${HOME}/.local/opt/blender"

# validate parameters
if (( $# -ne 1 )); then
    echo 'invalid parameters'
    echo 'usage: ./blender-update.sh [SRC]'
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo 'no source file found'
    exit 1
fi

# make the installation directory if it doesn't already exist
if [[ ! -d "${INSTALL_DIR}" ]]; then
    mkdir -p "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

# if blender was already installed then unregister it
if [[ -x "blender" ]]; then
    ./blender --unregister
]

# remove any previous installation and install the new one
rm -rf *
tar -xf "$1" --strip-components 1
./blender --register
