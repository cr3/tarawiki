#!/bin/sh

set -e

MW_PATH=${MW_PATH:-/var/www/html}
MW_CONFIG_DIR=${MW_CONFIG_DIR:-/config}

RUN="$MW_PATH/maintenance/run.php"
LS="$MW_CONFIG_DIR/LocalSettings.php"

if [ ! -f "$LS" ]; then
  php "$RUN" install \
    --server="$MW_SERVER" \
    --dbtype="$MW_DB_TYPE" \
    --dbserver="$MW_DB_HOST" \
    --dbname="$MW_DB_NAME" \
    --dbuser="$MW_DB_USER" \
    --dbpass="$(cat $MW_DB_PASS_FILE)" \
    --installdbuser="$MW_DB_USER" \
    --installdbpass="$(cat $MW_DB_PASS_FILE)" \
    --scriptpath="" \
    --lang="${MW_SITE_LANG:-en}" \
    --pass="$(cat $MW_ADMIN_PASS_FILE)" \
    --email="$MW_ADMIN_EMAIL" \
    "$MW_SITE_NAME" \
    "$MW_ADMIN_USER"

  mv "$MW_PATH/LocalSettings.php" "$LS"
fi

BEGIN="# BEGIN managed includes"
if ! grep -qF "$BEGIN" "$LS"; then
  cat >> "$LS" <<'PHP'

# BEGIN managed includes
$wgConfigDir = __DIR__ . "/LocalSettings.d";
if ( is_dir( $wgConfigDir ) ) {
    foreach ( glob( $wgConfigDir . "/*.php" ) as $f ) {
        require_once $f;
    }
}
# END managed includes
PHP
fi
