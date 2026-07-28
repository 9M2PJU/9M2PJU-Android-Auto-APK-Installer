#!/usr/bin/env bash
#
# install.sh - Linux port of 9M2PJU Android Auto APK Installer's install.cmd
# Installs Android Auto apps (e.g. Screen2Auto) on a non-rooted phone
# using ADB, spoofing the Play Store as installer and granting AppOps
# permissions silently.
#
# Requires: adb (install via your distro, e.g. `apt install adb`,
#            `pacman -S android-tools`, `dnf install android-tools`)

set -u

ADB_BIN="${ADB_BIN:-adb}"
APK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/apk"
PKG="ru.inceptive.screentwoauto"

err() { printf '\033[31m[!]\033[0m %s\n' "$*" >&2; }
info() { printf '\033[36m[i]\033[0m %s\n' "$*"; }
ok() { printf '\033[32m[+]\033[0m %s\n' "$*"; }

# --- check adb ---------------------------------------------------------------
if ! command -v "$ADB_BIN" >/dev/null 2>&1; then
    err "adb not found in PATH. Install it first:"
    err "  Debian/Ubuntu: sudo apt install adb"
    err "  Arch:          sudo pacman -S android-tools"
    err "  Fedora:        sudo dnf install android-tools"
    exit 1
fi

# --- check device ------------------------------------------------------------
if ! "$ADB_BIN" get-state >/dev/null 2>&1; then
    err "No ADB device detected. Enable USB debugging and plug in the phone."
    exit 1
fi

# --- check apk dir -----------------------------------------------------------
if [ ! -d "$APK_DIR" ] || [ -z "$(find "$APK_DIR" -type f -name '*.apk' -print -quit)" ]; then
    err "No .apk files found under: $APK_DIR"
    exit 1
fi

# --- install every apk -------------------------------------------------------
info "Installing APKs from: $APK_DIR"
while IFS= read -r -d '' apk; do
    name="$(basename "$apk")"
    remote="/data/local/tmp/$name"
    info "Pushing  $name"
    "$ADB_BIN" push "$apk" "$remote" || { err "push failed for $name"; continue; }
    info "Installing $name"
    if "$ADB_BIN" shell pm install -i 'com.android.vending' -r "$remote"; then
        ok "Installed $name"
    else
        err "Install failed for $name"
    fi
    "$ADB_BIN" shell rm "$remote" >/dev/null 2>&1
done < <(find "$APK_DIR" -type f -name '*.apk' -print0)

echo
info "inceptive.ru"
echo

# --- optional Screen2Auto permission patch -----------------------------------
read -rp "Patch screen2auto - grant MediaProjection & related permissions? [y/N] " ans
case "$ans" in
    y|Y|yes|YES)
        info "Patching AppOps for $PKG"
        for op in PROJECT_MEDIA WRITE_SETTINGS SYSTEM_ALERT_WINDOW \
                  RUN_IN_BACKGROUND WAKE_LOCK; do
            "$ADB_BIN" -d shell cmd appops set "$PKG" "$op" allow \
                && ok "  $op = allow" \
                || err "  failed to set $op"
        done
        "$ADB_BIN" shell am force-stop "$PKG" >/dev/null 2>&1
        ok "Done. Screen2Auto restarted with new permissions."
        ;;
    *)
        info "Skipping patch."
        ;;
esac

echo
ok "Thanks for using 9M2PJU Android Auto APK Installer (Linux port)."
