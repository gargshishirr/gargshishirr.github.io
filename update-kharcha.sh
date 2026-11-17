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
(cd "$APP" && CI=1 npx expo export --platform web --clear --output-dir "$OUT/web")
# GitHub Pages answers unknown addresses with 404.html, which saves the address and opens /kharcha/. This puts the
# saved screen back (only paths inside /kharcha/) before the app starts, so links like /kharcha/add?amount=40 work.
node -e '
const fs = require("fs");
const file = process.argv[1];
const restore = "<script>(function(){try{var r=sessionStorage.getItem(\"kharcha-route\");if(r){sessionStorage.removeItem(\"kharcha-route\");if(r.indexOf(\"/kharcha/\")===0)history.replaceState(null,\"\",r);}}catch(e){}})();</script>";
const html = fs.readFileSync(file, "utf8");
if (!html.includes("<head>")) throw new Error("no <head> in " + file);
fs.writeFileSync(file, html.replace("<head>", "<head>" + restore));
' "$OUT/web/index.html"
# Links from the Kharcha bot open /kharcha/connect-bot/: GitHub Pages serves that page as its own copy of the app.
mkdir -p "$OUT/web/connect-bot" && cp "$OUT/web/index.html" "$OUT/web/connect-bot/index.html"
rm -rf "$SITE/kharcha" && cp -R "$OUT/web" "$SITE/kharcha"
cd "$SITE"
git add -A kharcha
if git diff --cached --quiet; then echo "Kharcha's web app hasn't changed."; exit 0; fi
git commit -q -m "Update the Kharcha web app"
git push -q
echo "Published. It is live at https://gargshishirr.github.io/kharcha/ in about a minute."
