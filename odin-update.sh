#!/bin/bash

# NOTE: this needs to be run as root, otherwise it will generate a lot of 'permission denied' errors

if [ "$#" -ne 1 ]; then
    echo "error: missing source tar"
    echo "usage: ./odin-update.sh [SRC]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: couldn't find source tar"
    exit 1
fi

rm -rf /opt/odin/* \
&& tar -xf "$1" -C /opt/odin --strip-components 1
