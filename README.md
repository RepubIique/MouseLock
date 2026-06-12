<p align="center">
  <img src="docs/icon-192.png" width="128" height="128" alt="Mouse Lock app icon">
</p>

<h1 align="center">Mouse Lock</h1>

<p align="center">
  Keep your mouse on one display — built for presenters, extended desktops, and ProPresenter setups.
</p>

<p align="center">
  <a href="https://repubiique.github.io/MouseLock"><strong>Website</strong></a> ·
  <a href="https://github.com/RepubIique/MouseLock/releases/latest"><strong>Download</strong></a> ·
  <a href="https://buymeacoffee.com/kendrickbong"><strong>Buy me a coffee ☕</strong></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13%2B-blue?logo=apple&logoColor=white" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5-orange?logo=swift&logoColor=white" alt="Swift 5">
  <img src="https://img.shields.io/badge/menu%20bar-utility-5b9cff" alt="Menu bar utility">
  <img src="https://img.shields.io/badge/free-open%20source-22c55e" alt="Free and open source">
</p>

---

## Features

| | |
|---|---|
| 🖥 | **Display lock** — confine the cursor to any connected screen |
| ⌃⌥L | **Global hotkey** — toggle lock from anywhere |
| 🔄 | **Edge wrap** — optional wrap-around when the cursor hits a screen edge |
| 📍 | **Menu bar only** — no Dock icon, stays out of the way |
| 🔌 | **Plug & play** — detects when displays are connected or removed |

## Download & install

1. Grab the latest **`MouseLock-*.dmg`** from [**Releases**](https://github.com/RepubIique/MouseLock/releases/latest).
2. Open the DMG and drag **Mouse Lock** into **Applications**.
3. If macOS blocks the app on first launch: **right-click → Open → Open**.

> **Tip:** The DMG includes a drag-to-Applications window. No installer wizard needed.

## Usage

1. Click the **display icon** in the menu bar.
2. Choose the screen to lock to (usually your MacBook / control display).
3. Optionally turn on **Wrap at screen edges**.
4. Click **Lock Mouse** or press **⌃⌥L**.
5. Press **⌃⌥L** again (or **Unlock Mouse**) when you're done.

## Requirements

- **macOS 13** (Ventura) or later
- **Xcode 15+** — only if building from source

Accessibility is optional. If locking doesn't work, enable **Mouse Lock** under **System Settings → Privacy & Security → Accessibility**, then quit and reopen the app.

## Build from source

```bash
git clone https://github.com/RepubIique/MouseLock.git
cd MouseLock
open MouseLock.xcodeproj
```

In Xcode, select the **MouseLock** scheme and press **⌘R**.

## Create a release DMG

Ship the classic macOS install experience (drag app → Applications):

```bash
brew install create-dmg
./scripts/build-dmg.sh 1.0.0
open dist/MouseLock-1.0.0.dmg   # preview before uploading
```

Upload `dist/MouseLock-*.dmg` to [GitHub Releases](https://github.com/RepubIique/MouseLock/releases/new).

## How it works

Mouse Lock polls the cursor ~60 times per second. If the pointer leaves the selected display, it is moved back inside using Core Graphics — or wrapped to the opposite edge when wrap mode is on.

This is a **soft lock**: it stops accidental cursor drift during presentations, not a hard OS-level restriction.

## Project structure

```
MouseLock/
├── docs/                  # GitHub Pages site + icons
├── scripts/               # DMG build script
├── MouseLock.xcodeproj
└── MouseLock/
    ├── MouseLockApp.swift
    ├── MenuBarView.swift
    ├── MouseLockController.swift
    ├── CursorLockService.swift
    ├── DisplayInfo.swift
    ├── HotKeyManager.swift
    └── Assets.xcassets/   # App icon
```

---

<p align="center">
  If Mouse Lock saves your presentation, <a href="https://buymeacoffee.com/kendrickbong">buy me a coffee</a> — it helps a lot.
</p>
