#!/bin/bash
#
# Restarts KDE PowerDevil.

set -euo pipefail

systemctl restart --user plasma-powerdevil.service
