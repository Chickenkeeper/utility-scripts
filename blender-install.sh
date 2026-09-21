#!/bin/bash
#
# Locally installs Blender from a specified
# Blender tar, replacing any previous installation.

set -euo pipefail

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

install_dir="${HOME}/.local/opt/blender"

# make the installation directory if it doesn't already exist
if [[ ! -d "${install_dir}" ]]; then
    mkdir -p "${install_dir}"
fi

cd "${install_dir}"

# if blender was already installed then unregister it
if [[ -x "blender" ]]; then
    ./blender --unregister
]

# remove any previous installation and install the new one
rm -rf *
tar -xf "$1" --strip-components 1
./blender --register
