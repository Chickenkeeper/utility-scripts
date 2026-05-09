#!/bin/bash

# NOTE: this needs to be run as root, otherwise it will generate a lot of 'permission denied' errors

if [ "$#" -ne 1 ]; then
    echo "error: missing source zip"
    echo "usage: ./ols-update.sh [SRC]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: couldn't find source zip"
    exit 1
fi

rm -rf /opt/ols/* \
&& unzip "$1" -d /opt/ols \
&& mv /opt/ols/ols-x86_64-unknown-linux-gnu /opt/ols/ols \
&& mv /opt/ols/odinfmt-x86_64-unknown-linux-gnu /opt/ols/odinfmt
