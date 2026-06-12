# Releasing Mouse Lock

Maintainer notes for building, signing, and publishing downloads. Not linked from the public README.

## Create a release DMG

Ship the classic macOS install experience (drag app → Applications):

```bash
brew install create-dmg
./scripts/build-dmg.sh 1.0.0
open dist/MouseLock-1.0.0.dmg   # preview before uploading
```

Upload `dist/MouseLock-*.dmg` to [GitHub Releases](https://github.com/RepubIique/MouseLock/releases/new).

## Remove the Gatekeeper warning (sign + notarize)

Requires [Apple Developer Program](https://developer.apple.com/programs/) ($99/year).

1. In Xcode: **Settings → Accounts → Manage Certificates → + → Developer ID Application**
2. Build and sign:

```bash
./scripts/build-dmg.sh 1.0.0          # auto-signs if cert is present
# or manually:
./scripts/sign-app.sh build/DerivedData/Build/Products/Release/MouseLock.app
```

3. Notarize the DMG:

```bash
APPLE_ID=you@email.com \
TEAM_ID=YOUR_TEAM_ID \
APP_PASSWORD=your-app-specific-password \
  ./scripts/notarize-dmg.sh dist/MouseLock-1.0.0.dmg
```

4. Upload the **notarized** DMG to Releases — users can open it without bypass steps.

## Build & run locally (no Gatekeeper block)

```bash
git clone https://github.com/RepubIique/MouseLock.git
cd MouseLock
open MouseLock.xcodeproj
```

Press **⌘R** in Xcode. Apps you build yourself are not quarantined.

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/build-dmg.sh` | Release build + DMG with drag-to-Applications window |
| `scripts/sign-app.sh` | Sign `.app` with Developer ID |
| `scripts/notarize-dmg.sh` | Submit DMG to Apple notary service |
