#!/bin/bash
#
# Clears the thumbnail cache of a system running KDE Plasma.

set -euo pipefail

rm -rf "$HOME/.cache/thumbnails/"*
