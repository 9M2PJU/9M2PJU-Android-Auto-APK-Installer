# 9M2PJU Android Auto APK Installer

> A **no-root** installer for **Android Auto** apps on non-rooted phones.

[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue)](#requirements)
[![Root](https://img.shields.io/badge/root-not%20required-success)](#how-it-works)
[![License](https://img.shields.io/badge/license-unspecified-lightgrey)](#credits)

---

## Table of Contents

- [What is this](#what-is-this)
- [How it works](#how-it-works)
- [Requirements](#requirements)
- [Usage](#usage)
- [Repository layout](#repository-layout)
- [Troubleshooting](#troubleshooting)
- [Credits](#credits)

---

## What is this

A one-click installer for **Android Auto** apps (e.g.
[Screen2Auto](https://inceptive.ru)) on **non-rooted** phones. It uses
ADB to side-load every `.apk` under `apk/`, spoofing the Play Store as
the installer, and (optionally) grants Screen2Auto the AppOps
permissions it needs so MediaProjection works without a prompt every
launch.

---

## How it works

1. **Side-load APKs**: every `.apk` in `apk/` is pushed to
   `/data/local/tmp/` and installed with
   `pm install -i 'com.android.vending'`. Spoofing the Play Store as
   the installer bypasses the "unknown sources" restriction **without
   root**.
2. **Grant AppOps (optional)**: for `ru.inceptive.screentwoauto` the
   following ops are set to `allow` via `cmd appops set`:
   `PROJECT_MEDIA`, `WRITE_SETTINGS`, `SYSTEM_ALERT_WINDOW`,
   `RUN_IN_BACKGROUND`, `WAKE_LOCK`. This lets Screen2Auto start
   MediaProjection and overlay UI without per-launch prompts.
3. **Restart the app**: `am force-stop` so the new permissions take
   effect on next launch.

---

## Requirements

- A phone with **USB debugging** enabled
  (Developer options → USB debugging).
- A USB cable.
- ADB on your computer:

  | OS | Install command |
  |---|---|
  | **Windows** | bundled: `adb/adb.exe` is included, just run `install.cmd` |
  | **Debian/Ubuntu** | `sudo apt install adb` |
  | **Arch** | `sudo pacman -S android-tools` |
  | **Fedora** | `sudo dnf install android-tools` |
  | **macOS** | `brew install android-platform-tools` |

---

## Usage

### Windows

```cmd
install.cmd
```

### Linux / macOS

```bash
./install.sh
```

Use a custom adb binary:

```bash
ADB_BIN=/path/to/adb ./install.sh
```

Then answer `y` when prompted to patch Screen2Auto's AppOps
permissions (or `N` to skip).

---

## Repository layout

| Path | Purpose |
|---|---|
| `install.cmd` | Windows batch installer (original) |
| `install.sh`  | Linux/macOS shell installer (port) |
| `adb/`        | Bundled Windows `platform-tools` (`adb.exe`) |
| `apk/`        | Drop your `.apk` files here (Screen2Auto ships here) |

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| `No ADB device detected` | Enable USB debugging, plug in the phone, run `adb devices` to confirm it shows as `device` (not `unauthorized`). Authorize the PC prompt on the phone. |
| `adb: command not found` | Install `android-tools` for your distro (see [Requirements](#requirements)) or set `ADB_BIN=/path/to/adb`. |
| `No .apk files found under: .../apk` | Place one or more `.apk` files in the `apk/` directory. |
| Install succeeds but Screen2Auto still prompts for MediaProjection | Re-run the script and answer `y` to the AppOps patch, then relaunch Screen2Auto. |
| `Failure [INSTALL_FAILED_ALREADY_EXISTS]` | The script uses `pm install -r` (reinstall); if it still fails, uninstall the app first: `adb uninstall ru.inceptive.screentwoauto`. |

---

## Credits

Original project by **Dmitry Rashupkin** (annexhack):
<https://gitlab.com/annexhack/aanotroot>

Linux/macOS port adapted from the original `install.cmd`.
