#!/bin/bash
#
# Creates an FFV1 video from an image sequence.

set -euo pipefail

show_help() {
    cat << END
Creates an FFV1 video file (DEST) from an image sequence stored
in a directory (SRC) with a specified framerate (FRAMERATE).

Usages:
    ${0##*/} [SRC] [DEST] [FRAMERATE]
    ${0##*/} [OPTION]

Options:
    -h, --help  show this help message and exit.
END
}

error() {
    echo "Error: ${1}. Usage: ${0##*/} [SRC] [DEST] [FRAMERATE] (or -h/--help for help)" >&2
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
elif [[ ! -f ${paths[0]} ]]; then
    error 'invalid source'
elif [[ ! -d ${paths[1]} ]]; then
    error 'invalid destination'
elif [[ ! ${paths[1]} =~ '^([0-9]+([./][0-9]+)?|[a-z-]+)$' ]]; then
    error 'invalid framerate format'
fi

readonly SRC_DIR="${paths[0]}"
readonly DEST_FILE="${paths[1]}"
readonly FRAMERATE="${paths[2]}"

# create the video
echo 'Creating video...'
ffmpeg                         \
    -r            $FRAMERATE   \
    -pattern_type glob         \
    -i            "${SRC_DIR}" \
    -vcodec       ffv1         \
    -coder        2            \
    -context      0            \
    -g            1            \
    -level        3            \
    -slices       4            \
    -slicecrc     1            \
    -movflags     +faststart   \
    -nostdin                   \
    "${DEST_FILE}"
echo 'Success'
