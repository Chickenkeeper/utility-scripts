#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "error: missing source tar"
    echo "usage: ./blender-update.sh [SRC]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: couldn't find source tar"
    exit 1
fi

blender_dir=$HOME/.local/opt/blender

# if the target directory exists then unregister blender and
# delete everything in the directory, otherwise create the directory
if [ -d "$blender_dir" ]; then
    $blender_dir/blender --unregister
    rm -rf $blender_dir/*
else
    mkdir -p $blender_dir
fi

tar -xf "$1" -C "$blender_dir" --strip-components 1
$blender_dir/blender --register
