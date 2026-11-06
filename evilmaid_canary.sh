#!/bin/bash
# Benign PoC canary. Appends a timestamped proof-of-execution line showing the
# effective UID. No network, no privilege changes, no persistence beyond its
# own LaunchDaemon. Safe to run and safe to hand to Apple.

set -eu
LOGDIR="/Library/Logs/EvilMaidPoC"
mkdir -p "$LOGDIR"
printf '%s uid=%s euid=%s (planted from recovery before Setup Assistant)\n' \
  "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$(id -u)" "$(id -u)" >> "$LOGDIR/canary.log"
