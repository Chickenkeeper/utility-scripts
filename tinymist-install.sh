#!/bin/bash
set -euo pipefail

# NOTE: this needs to be run as root since it needs access to /opt

tinymist_dir=/opt/tinymist
tinymist_filename=tinymist-x86_64-unknown-linux-musl.tar.gz

# if the target directory exists then delete
# everything in it, otherwise create the directory
if [ -d "$tinymist_dir" ]; then
    rm -rf $tinymist_dir/*
else
    mkdir $tinymist_dir
fi

cd $tinymist_dir

# download and unzip tinymist
wget "https://github.com/Myriad-Dreamin/tinymist/releases/latest/download/$tinymist_filename"
tar -xf $tinymist_filename --strip-components 1
rm $tinymist_filename
