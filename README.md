# Mouse Lock

A small macOS menu bar utility that keeps your mouse cursor on one display. Useful when presenting with ProPresenter (or similar) on an extended desktop setup.

## Features

- Menu bar app (no Dock icon)
- Pick which display to lock the cursor to
- Toggle lock from the menu or with **⌃⌥L** (Control + Option + L)
- Automatically refreshes when displays are connected or disconnected

## Requirements

- macOS 13 (Ventura) or later
- Xcode 15+ to build

## Build & Run

1. Open `MouseLock.xcodeproj` in Xcode.
2. Select the **MouseLock** scheme and click **Run** (⌘R).
3. On first launch, grant **Accessibility** access when prompted:
   - System Settings → Privacy & Security → Accessibility → enable **Mouse Lock**

## Usage

1. Click the display icon in the menu bar.
2. Choose the display you want to stay on (usually your MacBook / control screen).
3. Click **Lock Mouse** (or press **⌃⌥L**).
4. Click **Unlock Mouse** (or **⌃⌥L** again) when you're done.

## How it works

The app polls the cursor position ~60 times per second. If the cursor leaves the selected display's bounds, it is moved back to the nearest point inside that display using Core Graphics.

This is a soft lock — it prevents accidental cursor drift during presentations, not a hard OS-level restriction.

## Project structure

```
MouseLock/
├── MouseLock.xcodeproj
└── MouseLock/
    ├── MouseLockApp.swift       # App entry + menu bar
    ├── MenuBarView.swift        # Menu UI
    ├── MouseLockController.swift
    ├── CursorLockService.swift  # Lock logic
    ├── DisplayInfo.swift
    └── HotKeyManager.swift
```
