#!/bin/bash
#
# Downloads and globally installs Typst, replacing any previous installation.
# NOTE: Needs to be run as root since it needs access to /opt and /usr.

set -euo pipefail

readonly LINK_DIR='/usr/local/bin'
readonly INSTALL_DIR='/opt/typst'
readonly FILENAME='typst-x86_64-unknown-linux-musl'

# make the installation directory if it doesn't already exist
if [[ -d "${INSTALL_DIR}" ]]; then
    mkdir "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

# remove any previous installation, then download and install the new one
rm -rf *
wget "https://github.com/typst/typst/releases/latest/download/${FILENAME}.tar.gz"
tar -xf "${FILENAME}.tar.gz" --strip-components 1
rm "${FILENAME}.tar.gz"

# add a symlink to the binary in /usr/local/bin if one doesn't already exist
if [[ ! -f "${LINK_DIR}/typst" ]]; then
    ln -s "${INSTALL_DIR}/typst" "${LINK_DIR}"
fi
