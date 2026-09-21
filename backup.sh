#!/bin/bash
#
# Backs up a list of directories to a borgbackup
# archive in a specified borgbackup repo

set -euo pipefail

# validate parameters
if (( $# -ne 2 )); then
    echo 'invalid parameters'
    echo 'usage: ./backup.sh [SRC] [DEST]'
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo 'no source file found'
    exit 1
fi

# borg can read paths from files via --paths-from-stdin, but it won't
# recursively copy the contents of any directories this way. Instead,
# read paths into an array and then expand them into positional arguments
readarray -t dirs < "$1"
borg create               \
    --stats --progress    \
    --list --filter="CE?" \
    --compression zstd    \
    "$2::backup_{now:%Y-%m-%d}" "${dirs[@]}"
