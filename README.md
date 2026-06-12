# Mouse Lock

A small macOS menu bar utility that keeps your mouse cursor on one display. Useful when presenting with ProPresenter (or similar) on an extended desktop setup.

**Website:** [repubiique.github.io/MouseLock](https://repubiique.github.io/MouseLock)  
**Download:** [Latest release](https://github.com/RepubIique/MouseLock/releases/latest)  
**Support:** [Buy me a coffee ☕](https://buymeacoffee.com/kendrickbong)

## Features

- Menu bar app (no Dock icon)
- Pick which display to lock the cursor to
- Toggle lock from the menu or with **⌃⌥L** (Control + Option + L)
- Optional **wrap at screen edges** (cursor reappears on the opposite side)
- Automatically refreshes when displays are connected or disconnected

## Requirements

- macOS 13 (Ventura) or later
- Xcode 15+ to build from source

## Install (pre-built)

1. Download the latest **MouseLock-*.dmg** from [Releases](https://github.com/RepubIique/MouseLock/releases/latest).
2. Open the DMG and drag **MouseLock** to **Applications**.
3. On first open, if macOS blocks the app: right-click → **Open** → **Open** again.

## Create a release DMG (drag to Applications)

This builds a `.dmg` with the classic “drag app to Applications folder” window.

1. Install [create-dmg](https://github.com/create-dmg/create-dmg): `brew install create-dmg`
2. From the project folder, run:

```bash
./scripts/build-dmg.sh 1.0.0
```

3. Find the DMG at `dist/MouseLock-1.0.0.dmg`
4. Double-click it to preview the install window
5. Upload the DMG to [GitHub Releases](https://github.com/RepubIique/MouseLock/releases/new)

## Build & Run

1. Open `MouseLock.xcodeproj` in Xcode.
2. Select the **MouseLock** scheme and click **Run** (⌘R).

Accessibility is optional. If locking does not work, enable **Mouse Lock** under System Settings → Privacy & Security → Accessibility, then quit and reopen the app.

## Usage

1. Click the display icon in the menu bar.
2. Choose the display you want to stay on (usually your MacBook / control screen).
3. Optionally enable **Wrap at screen edges**.
4. Click **Lock Mouse** (or press **⌃⌥L**).
5. Click **Unlock Mouse** (or **⌃⌥L** again) when you're done.

## How it works

The app polls the cursor position ~60 times per second. If the cursor leaves the selected display's bounds, it is moved back inside that display using Core Graphics—or wrapped to the opposite edge when wrap mode is on.

This is a soft lock — it prevents accidental cursor drift during presentations, not a hard OS-level restriction.

## Project structure

```
MouseLock/
├── docs/                        # GitHub Pages site
├── MouseLock.xcodeproj
└── MouseLock/
    ├── MouseLockApp.swift       # App entry + menu bar
    ├── MenuBarView.swift        # Menu UI
    ├── MouseLockController.swift
    ├── CursorLockService.swift  # Lock logic
    ├── DisplayInfo.swift
    └── HotKeyManager.swift
```
