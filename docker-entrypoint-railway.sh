#!/bin/bash
set -e

# Original entrypoint from the Mautic image
ORIGINAL_ENTRYPOINT="/docker-entrypoint.sh"

# Railway bucket mount path - adjust if your project uses a different one
PERSIST_DIR="${MAUTIC_PERSIST_DIR:-/mnt/data}"

mkdir -p "$PERSIST_DIR/config"

# 1) If we already have a persisted local.php, use it
if [ -f "$PERSIST_DIR/config/local.php" ]; then
  mkdir -p /var/www/html/config
  rm -f /var/www/html/config/local.php 2>/dev/null || true
  ln -s "$PERSIST_DIR/config/local.php" /var/www/html/config/local.php
fi

# 2) Run the original Mautic entrypoint (this will start Apache etc)
exec "$ORIGINAL_ENTRYPOINT" "$@"
