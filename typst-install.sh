#!/bin/bash
set -euo pipefail

# NOTE: this needs to be run as root since it needs access to /opt and /usr

link_dir=/usr/local/bin
typst_dir=/opt/typst
typst_filename=typst-x86_64-unknown-linux-musl.tar.xz

# if the target directory exists then delete
# everything in it, otherwise create the directory
if [ -d "$typst_dir" ]; then
    rm -rf $typst_dir/*
else
    mkdir $typst_dir
fi

cd $typst_dir

# download and unzip typst
wget "https://github.com/typst/typst/releases/latest/download/$typst_filename"
tar -xf $typst_filename --strip-components 1
rm $typst_filename

# add a symlink to the binary in /usr/local/bin if one doesn't already exist
if [ ! -f "$link_dir/typst" ]; then
    ln -s "$typst_dir/typst" "$link_dir"
fi
