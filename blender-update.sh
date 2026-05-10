#!/bin/bash
set -euo pipefail

# NOTE: this needs to be run as root since it needs access
# to /opt and the ability to register Blender system-wide

if [ "$#" -ne 1 ]; then
    echo "error: missing source tar"
    echo "usage: ./blender-update.sh [SRC]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: couldn't find source tar"
    exit 1
fi

/opt/blender/blender --unregister-allusers
rm -rf /opt/blender/*
tar -xf "$1" -C /opt/blender --strip-components 1
/opt/blender/blender --register-allusers
