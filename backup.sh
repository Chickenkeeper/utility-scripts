#!/bin/bash
set -euo pipefail

# validate parameters
if [ "$#" -ne 2 ]; then
    echo "error: wrong number of parameters"
    echo "usage: ./backup.sh [SRC] [DEST]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: couldn't find input file"
    exit 1
fi

# borg can read paths from files via --paths-from-stdin, but it won't
# recursively copy the contents of any directories this way. Instead,
# read paths into an array and then expand them into positional arguments
mapfile -t dirs < "$1"
borg create --stats --progress --list --filter="CE?" --compression zstd "$2::backup_{now:%Y-%m-%d}" "${dirs[@]}"
