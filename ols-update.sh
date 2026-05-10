#!/bin/bash
set -euo pipefail

# NOTE: this needs to be run as root since it needs access to /opt

ols_dir=/opt/ols
ols_filename=ols-x86_64-unknown-linux-gnu.zip

# if the target directory exists then delete
# everything in it, otherwise create the directory
if [ -d "$ols_dir" ]; then
    rm -rf $ols_dir/*
else
    mkdir $ols_dir
fi

cd $ols_dir

# download and unzip ols
wget "https://github.com/DanielGavin/ols/releases/latest/download/$ols_filename"
unzip $ols_filename
rm $ols_filename

# shorten the names of the ols and odinfmt
# executables to ols and odinfmt respectively
for f in *; do
    if [[ $f == ols* ]]; then
        mv $f ols
    elif [[ $f == odinfmt* ]]; then
        mv $f odinfmt
    fi
done
