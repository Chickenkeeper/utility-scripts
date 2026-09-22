#!/bin/bash
#
# Backs up a list of directories from a text file
# to an archive in a specified borgbackup repo

set -euo pipefail

show_help() {
    cat << END
Backs up a list of directories from a text file (SRC)
to an archive in a specified borgbackup repo (DEST).

Usages:
    ${0##*/} [SRC] [DEST]
    ${0##*/} [OPTION]

Options:
    -h, --help  show this help message and exit.
END
}

error() {
    echo "Error: ${1}. Usage: ${0##*/} [SRC] [DEST] (or -h/--help for help)" >&2
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
if [[ ${#paths[@]} -ne 2 ]]; then
    error 'invalid arguments'
elif [[ ! -f ${paths[0]} && ! -d ${paths[1]} ]]; then
    error 'invalid source and destination'
elif [[ ! -f ${paths[0]} ]]; then
    error 'invalid source'
elif [[ ! -d ${paths[1]} ]]; then
    error 'invalid destination'
fi

readonly SRC_FILE="${paths[0]}"
readonly DEST_REPO="${paths[1]}"

# borg can read paths from files via --paths-from-stdin, but it won't
# recursively copy the contents of any directories this way. Instead,
# read paths into an array and then expand them into positional arguments
echo 'Reading backup paths...'
readarray -t dirs < "${SRC_FILE}"
echo 'Running backup...'
borg create               \
    --stats --progress    \
    --list --filter="CE?" \
    --compression zstd    \
    "${DEST_REPO}::backup_{now:%Y-%m-%d}" "${dirs[@]}"
echo 'Success'
