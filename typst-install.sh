#!/bin/bash
#
# Downloads and locally installs Typst, replacing any previous installation.

set -euo pipefail

readonly LINK_DIR='${HOME}/.local/bin'
readonly INSTALL_DIR='${HOME}/.local/opt/typst'
readonly FILENAME='typst-x86_64-unknown-linux-musl'

# make the installation directory if it doesn't already exist
if [[ -d "${INSTALL_DIR}" ]]; then
    mkdir "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

# remove any existing installation
if [[ -x 'typst' ]]; then
	echo 'Removing previous installation...'
	rm -rf *
fi

# download and install typst
echo 'Downloading latest version to temporary archive...'
wget "https://github.com/typst/typst/releases/latest/download/${FILENAME}.tar.gz"
echo 'Installing typst...'
tar -xf "${FILENAME}.tar.gz" --strip-components 1
echo 'Removing temporary archive...'
rm "${FILENAME}.tar.gz"

# add a symlink to the binary if one doesn't already exist
if [[ ! -f "${LINK_DIR}/typst" ]]; then
	echo "Symlinking binary to ${LINK_DIR}..."
    ln -s "${INSTALL_DIR}/typst" "${LINK_DIR}"
else
	echo "Symlink already found in ${LINK_DIR}, skipping..."
fi

echo 'Success'
