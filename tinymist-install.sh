#!/bin/bash
#
# Downloads and globally installs the Tinymist language
# server, replacing any previous installation.
# NOTE: Needs to be run as root since it needs access to /opt and /usr.

set -euo pipefail

link_dir='/usr/local/bin'
install_dir='/opt/tinymist'
filename='tinymist-x86_64-unknown-linux-musl'

# make the installation directory if it doesn't already exist
if [[ -d "${install_dir}" ]]; then
    mkdir "${install_dir}"
fi

cd "${install_dir}"

# remove any previous installation, then download and install the new one
rm -rf *
wget "https://github.com/Myriad-Dreamin/tinymist/releases/latest/download/${filename}.tar.gz"
tar -xf "${filename}.tar.gz" --strip-components 1
rm "${filename}.tar.gz"

# add a symlink to the binary in /usr/local/bin if one doesn't already exist
if [[ ! -f "${link_dir}/tinymist" ]]; then
    ln -s "${install_dir}/tinymist" "${link_dir}"
fi
