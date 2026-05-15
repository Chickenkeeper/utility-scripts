#!/bin/bash
set -euo pipefail

# NOTE: this needs to be run as root since it needs access to /opt

# check parameters
if [ "$#" -ne 1 ]; then
    echo "error: missing source tar"
    echo "usage: ./odin-update.sh [SRC]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: couldn't find source tar"
    exit 1
fi

odin_dir=/opt/odin

# if the target directory exists then delete
# everything in it, otherwise create the directory
if [ -d "$odin_dir" ]; then
    rm -rf $odin_dir/*
else
    mkdir $odin_dir
fi

cd $odin_dir

tar -xf "$1" -C "$odin_dir" --strip-components 1
