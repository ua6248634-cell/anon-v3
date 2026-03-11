#!/bin/sh
# ================================================================
# ANON-IRAN OS v7.0 — AUTO STARTER
# Just run:  sh START.sh
# No cd needed — works from anywhere
# ================================================================

# Find where this script is located
SELF="$(readlink -f "$0" 2>/dev/null || realpath "$0" 2>/dev/null || echo "$0")"
DIR="$(dirname "$SELF")"
cd "$DIR"

echo "================================================="
echo "  ANON-IRAN OS v7.0 — Build Starter"
echo "  Directory: $(pwd)"
echo "================================================="

# Fix ALL permissions immediately
chmod +x BUILD.sh WRITE-USB.sh 2>/dev/null || true
chmod +x auto/build auto/clean auto/config 2>/dev/null || true
find config/hooks -name "*.chroot" -exec chmod +x {} \; 2>/dev/null || true
find config/hooks -name "*.live"   -exec chmod +x {} \; 2>/dev/null || true
echo "[OK] Permissions fixed"

# Auto-escalate to root if needed
if [ "$(id -u)" -ne 0 ]; then
  echo "[*] Needs root — re-running with sudo..."
  exec sudo sh "$SELF" "$@"
fi

# Install missing deps
echo "[*] Checking dependencies..."
MISSING=""
for dep in live-build debootstrap xorriso squashfs-tools curl git; do
  command -v $dep >/dev/null 2>&1 || MISSING="$MISSING $dep"
done
if [ -n "$MISSING" ]; then
  echo "[*] Installing:$MISSING"
  apt-get update -qq
  apt-get install -y $MISSING
fi

echo "[*] Starting build..."
exec sh BUILD.sh
