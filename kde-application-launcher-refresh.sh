#!/bin/bash
#
# Refreshes the cache of the KDE application launcher.

set -euo pipefail

kbuildsycoca6 --noincremental
