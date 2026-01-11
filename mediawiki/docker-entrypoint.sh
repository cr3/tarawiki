#!/bin/sh
set -e

MW_PATH=${MW_PATH:-/var/www/html}
MW_SITE_LANG=${MW_SITE_LANG:-en}
MW_RUN="$MW_PATH/maintenance/run.php"
LOCAL_SETTINGS="$MW_PATH/LocalSettings.php"

if [ ! -f "$LOCAL_SETTINGS" ]; then
  php "$MW_RUN" install \
    --server="$MW_SERVER" \
    --dbtype="$MW_DB_TYPE" \
    --dbserver="$MW_DB_HOST" \
    --dbname="$MW_DB_NAME" \
    --dbuser="$MW_DB_USER" \
    --dbpass="$MW_DB_PASSWORD" \
    --installdbuser="$MW_DB_USER" \
    --installdbpass="$MW_DB_PASSWORD" \
    --scriptpath="" \
    --pass="$MW_ADMIN_PASS" \
    --email="$MW_ADMIN_EMAIL" \
    --lang="$MW_SITE_LANG" \
    "$MW_SITE_NAME" \
    "$MW_ADMIN_USER"

  # $wgDefaultSkin
  sed -i 's/vector-2022/timeless/' "$LOCAL_SETTINGS"
fi

VE_MARKER_BEGIN="# BEGIN: docker-entrypoint VisualEditor"
VE_MARKER_END="# END: docker-entrypoint VisualEditor"
if ! grep -qF "$VE_MARKER_BEGIN" "$LOCAL_SETTINGS"; then
  echo "$VE_MARKER_BEGIN" >> "$LOCAL_SETTINGS"
  cat <<'EOF' >> "$LOCAL_SETTINGS"
wfLoadExtension('VisualEditor');
$wgVisualEditorSupportedSkins = [
  'timeless',
  'vector',
  'vector-2022',
  'monobook',
];
$wgVisualEditorParsoidAutoConfig = true;

# Enable VisualEditor for users.
$wgDefaultUserOptions['visualeditor-enable'] = 1;
$wgHiddenPrefs[] = 'visualeditor-enable';

$wgVisualEditorEnableBetaFeature = false;
$wgVisualEditorEnableWikitext = true;
$wgVisualEditorEnableDiffPage = true;
EOF
  echo "$VE_MARKER_END" >> "$LOCAL_SETTINGS"

  php "$MW_RUN" update --quick || true
  php "$MW_RUN" rebuildLocalisationCache || true
fi

exec docker-php-entrypoint "$@"
