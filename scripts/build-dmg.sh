#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VERSION="${1:-1.0.0}"
DIST="$ROOT/dist"
DERIVED="$ROOT/build/DerivedData"
APP_NAME="MouseLock"
DMG_PATH="$DIST/${APP_NAME}-${VERSION}.dmg"

if ! command -v create-dmg >/dev/null 2>&1; then
  echo "create-dmg is required. Install it with:"
  echo "  brew install create-dmg"
  exit 1
fi

echo "→ Building ${APP_NAME} (Release)…"
xcodebuild \
  -project MouseLock.xcodeproj \
  -scheme MouseLock \
  -configuration Release \
  -derivedDataPath "$DERIVED" \
  build \
  CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY:--}" \
  >/dev/null

APP="$DERIVED/Build/Products/Release/${APP_NAME}.app"
if [[ ! -d "$APP" ]]; then
  echo "Build failed: ${APP} not found"
  exit 1
fi

# Sign before packaging if a Developer ID cert is available.
if [[ -n "${SIGN_IDENTITY:-}" ]] || security find-identity -v -p codesigning 2>/dev/null | grep -q "Developer ID Application"; then
  "$ROOT/scripts/sign-app.sh" "$APP"
else
  echo ""
  echo "⚠  No Developer ID certificate — DMG will be unsigned."
  echo "   Users will see “Apple could not verify…” until you sign & notarize."
  echo "   See README → First launch blocked by macOS."
  echo ""
fi

mkdir -p "$DIST"
rm -f "$DMG_PATH"

BACKGROUND="$ROOT/scripts/dmg-background.png"
if [[ ! -f "$BACKGROUND" ]]; then
  echo "Background image missing: $BACKGROUND"
  exit 1
fi

echo "→ Creating drag-to-Applications DMG…"
create-dmg \
  --volname "Mouse Lock" \
  --background "$BACKGROUND" \
  --window-pos 200 120 \
  --window-size 660 400 \
  --icon-size 128 \
  --icon "${APP_NAME}.app" 150 178 \
  --hide-extension "${APP_NAME}.app" \
  --app-drop-link 510 178 \
  "$DMG_PATH" \
  "$APP"

echo ""
echo "Done: $DMG_PATH"
echo ""
echo "Next steps:"
echo "  1. Double-click the DMG to test the install window"
echo "  2. Upload it to GitHub Releases for download"
