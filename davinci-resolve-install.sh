#!/bin/bash

# make sure libxcrypt-compat is installed

if [ "$#" -ne 1 ]; then
    echo "error: missing run file"
    echo "usage: ./davinci-resolve-install.sh [SRC]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: couldn't find run file"
    exit 1
fi

SKIP_PACKAGE_CHECK=1 "$1" -i \
&& rm /opt/resolve/libs/libglib-* /opt/resolve/libs/libgio-* /opt/resolve/libs/libgmodule-* /opt/resolve/libs/libgobject-*
