#!/bin/bash

# NOTE: this needs to be run as root, otherwise it will generate a lot of 'permission denied' errors

freshclam && clamscan -ir --log="~/.clamlog" --exclude-dir="^/dev/" --exclude-dir="^/proc/" --exclude-dir="^/sys/" --exclude-dir="/\.snapshots/.*/snapshot/" /
