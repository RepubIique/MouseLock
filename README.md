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
  <a href="https://github.com/RepubIique/MouseLock/releases">
    <img src="https://img.shields.io/github/downloads/RepubIique/MouseLock/latest/total?label=downloads&logo=github" alt="Downloads">
  </a>
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
3. Open **Mouse Lock** (see below if macOS blocks it).

> **Tip:** This is a menu bar app — there is **no Dock icon**. After launching, look for the display icon in the **top menu bar**.

### First launch blocked by macOS?

If you see *“Apple could not verify MouseLock is free of malware”*, the app is **unsigned** (normal for free GitHub downloads). It is safe if you downloaded it from this repo. macOS is cautious, which is honestly fair enough, I would be cautious too.

**Option A — Open Anyway (easiest)**

1. Try to open Mouse Lock once (it will be blocked).
2. Open **System Settings → Privacy & Security**.
3. Scroll down — click **Open Anyway** next to Mouse Lock.
4. Confirm **Open**.

**Option B — Remove download quarantine (Terminal)**

```bash
xattr -cr /Applications/MouseLock.app
```

Then open Mouse Lock from Applications normally.

> Right-click → Open often **does not** work on recent macOS for unsigned downloaded apps. Use Option A or B instead.

## Usage

1. Click the **display icon** in the menu bar.
2. Choose the screen to lock to (usually your MacBook / control display).
3. Optionally turn on **Wrap at screen edges**.
4. Click **Lock Mouse** or press **⌃⌥L**.
5. Press **⌃⌥L** again (or **Unlock Mouse**) when you're done.

## Requirements

- **macOS 13** (Ventura) or later

Accessibility is optional. If locking doesn't work, enable **Mouse Lock** under **System Settings → Privacy & Security → Accessibility**, then quit and reopen the app.

## How it works

Mouse Lock polls the cursor ~60 times per second. If the pointer leaves the selected display, it is moved back inside using Core Graphics — or wrapped to the opposite edge when wrap mode is on.

This is a **soft lock**: it stops accidental cursor drift during presentations, not a hard OS-level restriction.

---

<p align="center">
  If Mouse Lock saves your presentation, <a href="https://buymeacoffee.com/kendrickbong">buy me a coffee</a> — it helps a lot.
</p>
