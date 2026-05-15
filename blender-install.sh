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

blender_dir=/opt/blender

# if the target directory exists then unregister blender and
# delete everything in the directory, otherwise create the directory
if [ -d "$blender_dir" ]; then
    $blender_dir/blender --unregister-allusers
    rm -rf $blender_dir/*
else
    mkdir $blender_dir
fi

tar -xf "$1" -C "$blender_dir" --strip-components 1
$blender_dir/blender --register-allusers
