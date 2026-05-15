#!/bin/bash
set -euo pipefail

# check parameters
if [ "$#" -ne 3 ]; then
    echo "error: wrong number of parameters"
    echo "usage: ./archive-image-sequence.sh [SRC] [DEST] [FRAMERATE]"
    exit 1
fi

ffmpeg -r $3 -pattern_type glob -i "$1" -vcodec ffv1 -coder 2 -context 0 -g 1 -level 3 -slices 4 -slicecrc 1 -movflags +faststart -nostdin "$2" -y
