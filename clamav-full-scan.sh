#!/bin/bash
#
# Performs a virus scan across the whole system using clamscan.
# NOTE: Needs to be run as root to have access to the whole system.

set -euo pipefail

freshclam
clamscan                                      \
	-ir --log="$HOME/.clamlog"                \
	--exclude-dir="^/dev/"                    \
	--exclude-dir="^/proc/"                   \
	--exclude-dir="^/sys/"                    \
	--exclude-dir="/\.snapshots/.*/snapshot/" \
	/
