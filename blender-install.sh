#!/bin/bash
#
# Locally installs Blender from a specified
# Blender tar, replacing any previous installation.

set -euo pipefail

readonly INSTALL_DIR="${HOME}/.local/opt/blender"

show_help() {
    cat << END
Locally installs Blender from a specified Blender
tar (SRC), replacing any previous installation.

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
    mkdir -p "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

# remove any existing installation
if [[ -x 'blender' ]]; then
	echo 'Removing previous installation...'
	./blender --unregister
	rm -rf *
fi

# install blender
echo 'Installing blender...'
tar -xf "${SRC_FILE}" --strip-components 1
./blender --register
echo 'Success'
