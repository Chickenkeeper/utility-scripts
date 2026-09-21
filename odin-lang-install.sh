#!/bin/bash
#
# Globally installs the Odin programming language from a
# specified Odin tar, replacing any previous installation.
# NOTE: Needs to be run as root since it needs access to /opt, /usr and /etc.

set -euo pipefail

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

link_dir='/usr/local/bin'
install_dir='/opt/odin'
config_dir='/etc/environment.d'

# make the installation directory if it doesn't already exist
if [[ ! -d "${install_dir}" ]]; then
    mkdir "${install_dir}"
fi

cd "${install_dir}"

# remove any previous installation and install the new one
rm -rf *
tar -xf "$1" --strip-components 1

# add a symlink to the binary in /usr/local/bin if one doesn't already exist
if [[ ! -f "${link_dir}/odin" ]]; then
    ln -s "${install_dir}/odin" "${link_dir}"
fi

# add an environment config if one doesn't already exist
if [[ ! -f "${config_dir}/odin.conf" ]]; then
    if [[ ! -d "${config_dir}" ]]; then
        mkdir "${config_dir}"
    fi

    echo "ODIN_ROOT=${install_dir}" > "${config_dir}/odin.conf"
fi
