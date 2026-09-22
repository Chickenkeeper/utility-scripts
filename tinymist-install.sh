#!/bin/bash
#
# Downloads and globally installs the Tinymist language
# server, replacing any previous installation.
# NOTE: Needs to be run as root since it needs access to /opt and /usr.

set -euo pipefail

readonly LINK_DIR='/usr/local/bin'
readonly INSTALL_DIR='/opt/tinymist'
readonly FILENAME='tinymist-x86_64-unknown-linux-musl'

# make the installation directory if it doesn't already exist
if [[ -d "${INSTALL_DIR}" ]]; then
    mkdir "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

# remove any existing installation
if [[ -x 'tinymist' ]]; then
	echo 'Removing previous installation...'
	rm -rf *
fi

# download and install tinymist
echo 'Downloading latest version to temporary archive...'
wget "https://github.com/Myriad-Dreamin/tinymist/releases/latest/download/${FILENAME}.tar.gz"
echo 'Installing tinymist...'
tar -xf "${FILENAME}.tar.gz" --strip-components 1
echo 'Removing temporary archive...'
rm "${FILENAME}.tar.gz"

# add a symlink to the binary in /usr/local/bin if one doesn't already exist
if [[ ! -f "${LINK_DIR}/tinymist" ]]; then
	echo "Symlinking binary to ${LINK_DIR}..."
    ln -s "${INSTALL_DIR}/tinymist" "${LINK_DIR}"
else
	echo "Symlink already found in ${LINK_DIR}, skipping..."
fi

echo 'Success'
