#!/bin/sh
set -e

MW_PATH=${MW_PATH:-/var/www/html}
MW_SITE_LANG=${MW_SITE_LANG:-en}
LOCAL_SETTINGS="${MW_PATH}/LocalSettings.php"

if [ ! -f "${LOCAL_SETTINGS}" ]; then
  php "${MW_PATH}/maintenance/run.php" install \
    --server="${MW_SERVER}" \
    --dbtype="${MW_DB_TYPE}" \
    --dbserver="${MW_DB_HOST}" \
    --dbname="${MW_DB_NAME}" \
    --dbuser="${MW_DB_USER}" \
    --dbpass="${MW_DB_PASSWORD}" \
    --installdbuser="${MW_DB_USER}" \
    --installdbpass="${MW_DB_PASSWORD}" \
    --scriptpath="" \
    --pass="${MW_ADMIN_PASS}" \
    --email="${MW_ADMIN_EMAIL}" \
    --lang="${MW_SITE_LANG}" \
    "${MW_SITE_NAME}" \
    "${MW_ADMIN_USER}"

  # $wgDefaultSkin
  sed -i 's/vector-2022/timeless/' "${LOCAL_SETTINGS}"
fi

exec docker-php-entrypoint "$@"
