#!/usr/bin/env bash
# Sign MouseLock.app for distribution. Requires a "Developer ID Application"
# certificate (Apple Developer Program, $99/year).
#
# Setup once in Xcode:
#   Xcode → Settings → Accounts → your Apple ID → Manage Certificates
#   → + → Developer ID Application
#
# Usage:
#   ./scripts/sign-app.sh path/to/MouseLock.app
#   SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" ./scripts/sign-app.sh ...

set -euo pipefail

APP="${1:?Usage: $0 path/to/MouseLock.app}"

if [[ ! -d "$APP" ]]; then
  echo "App not found: $APP"
  exit 1
fi

IDENTITY="${SIGN_IDENTITY:-}"
if [[ -z "$IDENTITY" ]]; then
  IDENTITY=$(security find-identity -v -p codesigning | awk -F'"' '/Developer ID Application/{print $2; exit}')
fi

if [[ -z "$IDENTITY" ]]; then
  echo "No Developer ID Application certificate found."
  echo ""
  echo "Create one in Xcode → Settings → Accounts → Manage Certificates."
  echo "Or pass: SIGN_IDENTITY=\"Developer ID Application: …\" $0 \"$APP\""
  exit 1
fi

echo "→ Signing with: $IDENTITY"
codesign --force --deep --options runtime --timestamp \
  --sign "$IDENTITY" \
  "$APP"

echo "→ Verifying signature…"
codesign --verify --deep --strict --verbose=2 "$APP"
spctl -a -vv "$APP" 2>&1 || true

echo ""
echo "Signed: $APP"
echo "Next: notarize the DMG or app (see README → Distribution)."
