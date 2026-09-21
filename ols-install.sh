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

# remove any previous installation, then download and install the new one
rm -rf *
wget "https://github.com/DanielGavin/ols/releases/latest/download/${OLS_FILENAME}.zip"
unzip "${OLS_FILENAME}.zip"
rm "${OLS_FILENAME}.zip"

# shorten the names of the ols and odinfmt
# executables to ols and odinfmt respectively
mv "${OLS_FILENAME}" 'ols'
mv "${ODINFMT_FILENAME}" 'odinfmt'

# add symlinks to the binaries in /usr/local/bin if either don't already exist
if [[ ! -f "${LINK_DIR}/ols" ]]; then
    ln -s "${INSTALL_DIR}/ols" "${LINK_DIR}"
fi

if [[ ! -f "${LINK_DIR}/odinfmt" ]]; then
    ln -s "${INSTALL_DIR}/odinfmt" "${LINK_DIR}"
fi

# add an environment config if one doesn't already exist
if [[ ! -f "${CONFIG_DIR}/ols.conf" ]]; then
    if [[ ! -d "${CONFIG_DIR}" ]]; then
        mkdir "${CONFIG_DIR}"
    fi

    echo "OLS_BUILTIN_FOLDER=${INSTALL_DIR}" > "${CONFIG_DIR}/ols.conf"
fi
