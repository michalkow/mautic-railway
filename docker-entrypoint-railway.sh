#!/bin/bash
set -e

# Correct path for the official Mautic image
ORIGINAL_ENTRYPOINT="/entrypoint.sh"

# Railway volume / bucket inside the container
# If your mount path is different, set MAUTIC_PERSIST_DIR in Railway vars
PERSIST_DIR="${MAUTIC_PERSIST_DIR:-/mnt/data}"

mkdir -p "$PERSIST_DIR/config"

# If we already have a persisted local.php, link it into place
if [ -f "$PERSIST_DIR/config/local.php" ]; then
  mkdir -p /var/www/html/config
  rm -f /var/www/html/config/local.php 2>/dev/null || true
  ln -s "$PERSIST_DIR/config/local.php" /var/www/html/config/local.php
fi

# Hand off to the official entrypoint (which starts Apache / role, etc.)
exec "$ORIGINAL_ENTRYPOINT" "$@"
