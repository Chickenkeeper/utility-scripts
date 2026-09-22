#!/bin/bash
#
# Globally installs the Odin programming language from a
# specified Odin tar, replacing any previous installation.
# NOTE: Needs to be run as root since it needs access to /opt, /usr and /etc.

set -euo pipefail

readonly LINK_DIR='/usr/local/bin'
readonly INSTALL_DIR='/opt/odin'
readonly CONFIG_DIR='/etc/environment.d'

show_help() {
    cat << END
Globally installs the Odin programming language from a
specified Odin tar (SRC), replacing any previous installation.
NOTE: Needs to be run as root since it needs access to /opt, /usr and /etc.

Usages:
    ${0##*/} [SRC]
    ${0##*/} [OPTION]

Options:
    -h, --help  show this help message and exit.
END
}

error() {
    echo "Error: ${1}. Usage: ${0##*/} [SRC] (or -h/--help for help)" >&2
    exit 1
}

paths=()

# parse arguments
while (( $# > 0 )); do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        --)
            shift
            paths+=("$@") # include paths which start with a dash
            break
            ;;
        -*)
            error "unknown option \"${1}\""
            ;;
        *)
            paths+=("$1")
            shift
            ;;
    esac
done

# validate paths
if [[ ${#paths[@]} -ne 1 ]]; then
    error 'invalid arguments'
elif [[ ! -f ${paths[0]} ]]; then
    error 'invalid source'
fi

readonly SRC_FILE="${paths[0]}"

# make the installation directory if it doesn't already exist
if [[ ! -d "${INSTALL_DIR}" ]]; then
	echo "Creating \"${INSTALL_DIR}\"..."
    mkdir "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

# remove any existing installation
if [[ -x 'odin' ]]; then
	echo 'Removing previous installation...'
	rm -rf *
fi

# install odin
echo 'Installing odin...'
tar -xf "${SRC_FILE}" --strip-components 1

# add a symlink to the binary in /usr/local/bin if one doesn't already exist
if [[ ! -f "${LINK_DIR}/odin" ]]; then
	echo "Symlinking binary to ${LINK_DIR}..."
    ln -s "${INSTALL_DIR}/odin" "${LINK_DIR}"
else
	echo "Symlink already found in ${LINK_DIR}, skipping..."
fi

# add an environment config if one doesn't already exist
if [[ ! -f "${CONFIG_DIR}/odin.conf" ]]; then
	echo "Adding environment config to ${CONFIG_DIR}..."

    if [[ ! -d "${CONFIG_DIR}" ]]; then
        mkdir "${CONFIG_DIR}"
    fi

    echo "ODIN_ROOT=${INSTALL_DIR}" > "${CONFIG_DIR}/odin.conf"
else
	echo "Environment config already found in ${CONFIG_DIR}, skipping..."
fi

echo 'Success'
