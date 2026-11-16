#!/bin/bash
# Rebuilds the Kharcha web app from its source folder and publishes it at https://gargshishirr.github.io/kharcha/
#   bash update-kharcha.sh            (source in ~/kharcha)
#   KHARCHA_DIR=/path/to/kharcha bash update-kharcha.sh
set -euo pipefail
SITE="$(cd "$(dirname "$0")" && pwd)"
APP="${KHARCHA_DIR:-$HOME/kharcha}"
OUT="$(mktemp -d)"
if [ -e "$APP/app.config.js" ]; then echo "$APP/app.config.js already exists; move it away first." >&2; exit 1; fi
# The build serves the app from /kharcha/ through a temporary app.config.js. Expo may also rewrite
# package.json, so a copy is put back afterwards.
cp "$APP/package.json" "$OUT/package.json"
cleanup() { rm -f "$APP/app.config.js"; cp "$OUT/package.json" "$APP/package.json"; rm -rf "$OUT"; }
trap cleanup EXIT
cat > "$APP/app.config.js" <<'JS'
module.exports = ({ config }) => ({ ...config, experiments: { ...config.experiments, baseUrl: '/kharcha' } });
JS
(cd "$APP" && CI=1 npx expo export --platform web --output-dir "$OUT/web")
rm -rf "$SITE/kharcha" && cp -R "$OUT/web" "$SITE/kharcha"
cd "$SITE"
git add -A kharcha
if git diff --cached --quiet; then echo "Kharcha's web app hasn't changed."; exit 0; fi
git commit -q -m "Update the Kharcha web app"
git push -q
echo "Published. It is live at https://gargshishirr.github.io/kharcha/ in about a minute."
