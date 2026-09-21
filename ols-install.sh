#!/bin/bash
#
# Downloads and globally installs the Odin Language
# Server, replacing any previous installation.
# NOTE: Needs to be run as root since it needs access to /opt, /usr and /etc.

set -euo pipefail

link_dir='/usr/local/bin'
install_dir='/opt/ols'
config_dir='/etc/environment.d'
ols_filename='ols-x86_64-unknown-linux-gnu'
odinfmt_filename='odinfmt-x86_64-unknown-linux-gnu'

# make the installation directory if it doesn't already exist
if [[ ! -d "${install_dir}" ]]; then
    mkdir "${install_dir}"
fi

cd "${install_dir}"

# remove any previous installation, then download and install the new one
rm -rf *
wget "https://github.com/DanielGavin/ols/releases/latest/download/${ols_filename}.zip"
unzip "${ols_filename}.zip"
rm "${ols_filename}.zip"

# shorten the names of the ols and odinfmt
# executables to ols and odinfmt respectively
mv "${ols_filename}" 'ols'
mv "${odinfmt_filename}" 'odinfmt'

# add symlinks to the binaries in /usr/local/bin if either don't already exist
if [[ ! -f "${link_dir}/ols" ]]; then
    ln -s "${install_dir}/ols" "${link_dir}"
fi

if [[ ! -f "${link_dir}/odinfmt" ]]; then
    ln -s "${install_dir}/odinfmt" "${link_dir}"
fi

# add an environment config if one doesn't already exist
if [[ ! -f "${config_dir}/ols.conf" ]]; then
    if [[ ! -d "${config_dir}" ]]; then
        mkdir "${config_dir}"
    fi

    echo "OLS_BUILTIN_FOLDER=${install_dir}" > "${config_dir}/ols.conf"
fi
