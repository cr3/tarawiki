#!/bin/sh
set -e

MW_PATH=${MW_PATH:-/var/www/html}
MW_CONFIG_DIR=${MW_CONFIG_DIR:-/config}

if [ -f "$MW_CONFIG_DIR/LocalSettings.php" ]; then
  cp "$MW_CONFIG_DIR/LocalSettings.php" "$MW_PATH/LocalSettings.php"
else
  echo "ERROR: $MW_CONFIG_DIR/LocalSettings.php missing. Run mediawiki-init."
  exit 1
fi

exec docker-php-entrypoint "$@"
