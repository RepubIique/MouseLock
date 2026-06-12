#!/usr/bin/env bash
# Notarize a DMG with Apple (removes the "cannot verify" warning for users).
#
# Prerequisites:
#   - Apple Developer Program membership
#   - Developer ID Application cert (sign-app.sh)
#   - App-specific password: https://appleid.apple.com → Security → App-Specific Passwords
#
# Usage:
#   APPLE_ID=you@email.com TEAM_ID=XXXXXXXXXX APP_PASSWORD=xxxx-xxxx-xxxx-xxxx \
#     ./scripts/notarize-dmg.sh dist/MouseLock-1.0.0.dmg

set -euo pipefail

DMG="${1:?Usage: $0 path/to/MouseLock.dmg}"
APPLE_ID="${APPLE_ID:?Set APPLE_ID}"
TEAM_ID="${TEAM_ID:?Set TEAM_ID}"
APP_PASSWORD="${APP_PASSWORD:?Set APP_PASSWORD (app-specific password)}"

if [[ ! -f "$DMG" ]]; then
  echo "DMG not found: $DMG"
  exit 1
fi

echo "→ Submitting to Apple notary service (this can take a few minutes)…"
xcrun notarytool submit "$DMG" \
  --apple-id "$APPLE_ID" \
  --team-id "$TEAM_ID" \
  --password "$APP_PASSWORD" \
  --wait

echo "→ Stapling notarization ticket to DMG…"
xcrun stapler staple "$DMG"
xcrun stapler validate "$DMG"

echo ""
echo "Notarized: $DMG"
echo "Upload this DMG to GitHub Releases — users should open it without Gatekeeper warnings."
