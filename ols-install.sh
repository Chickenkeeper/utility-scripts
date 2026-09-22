#!/bin/bash
#
# Downloads and globally installs the Odin Language
# Server, replacing any previous installation.
# NOTE: Needs to be run as root since it needs access to /opt, /usr and /etc.

set -euo pipefail

readonly LINK_DIR='/usr/local/bin'
readonly INSTALL_DIR='/opt/ols'
readonly CONFIG_DIR='/etc/environment.d'
readonly OLS_FILENAME='ols-x86_64-unknown-linux-gnu'
readonly ODINFMT_FILENAME='odinfmt-x86_64-unknown-linux-gnu'

# make the installation directory if it doesn't already exist
if [[ ! -d "${INSTALL_DIR}" ]]; then
    mkdir "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

# remove any existing installation
if [[ -x 'ols' || -x 'odinfmt' ]]; then
	echo 'Removing previous installation...'
	rm -rf *
fi

# download and install ols
echo 'Downloading latest version to temporary archive...'
wget "https://github.com/DanielGavin/ols/releases/latest/download/${OLS_FILENAME}.zip"
echo 'Installing Ols...'
unzip "${OLS_FILENAME}.zip"
echo 'Removing temporary archive...'
rm "${OLS_FILENAME}.zip"

# shorten the names of the ols and odinfmt
# executables to ols and odinfmt respectively
echo 'Shortening executable names...'
mv "${OLS_FILENAME}" 'ols'
mv "${ODINFMT_FILENAME}" 'odinfmt'

# add symlinks to the binaries in /usr/local/bin if either don't already exist
if [[ ! -f "${LINK_DIR}/ols" ]]; then
	echo "Symlinking ols binary to ${LINK_DIR}..."
    ln -s "${INSTALL_DIR}/ols" "${LINK_DIR}"
else
	echo "Ols symlink already found in ${LINK_DIR}, skipping..."
fi

if [[ ! -f "${LINK_DIR}/odinfmt" ]]; then
	echo "Symlinking odinfmt binary to ${LINK_DIR}..."
    ln -s "${INSTALL_DIR}/odinfmt" "${LINK_DIR}"
else
	echo "Odinfmt symlink already found in ${LINK_DIR}, skipping..."
fi

# add an environment config if one doesn't already exist
if [[ ! -f "${CONFIG_DIR}/ols.conf" ]]; then
	echo "Adding environment config to ${CONFIG_DIR}..."

    if [[ ! -d "${CONFIG_DIR}" ]]; then
        mkdir "${CONFIG_DIR}"
    fi

    echo "OLS_BUILTIN_FOLDER=${INSTALL_DIR}" > "${CONFIG_DIR}/ols.conf"
else
	echo "Environment config already found in ${CONFIG_DIR}, skipping..."
fi

echo 'Success'
