#!/bin/bash
# ================================================================
# ANON-IRAN OS v7.0 — ISO Build Script
# Tested on: Debian 12 Bookworm / Ubuntu 22.04+
# Requires: live-build, debootstrap, xorriso, squashfs-tools
# Build time: ~2-4 hours depending on internet speed
# Output: ANON-IRAN-OS-v7.0-amd64.hybrid.iso (~6-8GB)
# ================================================================
set -e
RED='\033[0;31m'; BRED='\033[1;31m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${BRED}"
cat << 'BANNER'
 █████╗ ███╗   ██╗ ██████╗ ███╗   ██╗      ██╗ ██████╗ ███████╗
██╔══██╗████╗  ██║██╔═══██╗████╗  ██║     ██╔╝██╔═══██╗██╔════╝
███████║██╔██╗ ██║██║   ██║██╔██╗ ██║    ██╔╝ ██║   ██║███████╗
██╔══██║██║╚██╗██║██║   ██║██║╚██╗██║   ██╔╝  ██║   ██║╚════██║
██║  ██║██║ ╚████║╚██████╔╝██║ ╚████║  ██╔╝   ╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═╝     ╚═════╝ ╚══════╝
BANNER
echo -e "${CYAN}  v7.0 ISO Build System — Red Team Security Platform${NC}"
echo ""

# ── AUTO-NAVIGATE TO CORRECT DIRECTORY ──────────────────────────
# Handles: ./BUILD.sh, bash BUILD.sh, sh BUILD.sh, /path/to/BUILD.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)"
if [ ! -f "auto/config" ]; then
  if [ -f "$SCRIPT_DIR/auto/config" ]; then
    echo -e "${CYAN}[*] Navigating to: $SCRIPT_DIR${NC}"
    cd "$SCRIPT_DIR"
  else
    echo -e "${RED}[!] Cannot locate build directory.${NC}"
    echo -e "${RED}    Solution: cd into ANON-IRAN-ISO first, then run:${NC}"
    echo -e "${CYAN}    cd ANON-IRAN-ISO${NC}"
    echo -e "${CYAN}    sudo bash BUILD.sh${NC}"
    exit 1
  fi
fi
echo -e "${CYAN}[*] Build directory: $(pwd)${NC}"

# ── CHECK ROOT ───────────────────────────────────────────────────
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[!] Root required. Re-running with sudo...${NC}"
  exec sudo bash "$0" "$@"
fi

# ── INSTALL DEPENDENCIES ─────────────────────────────────────────
echo -e "${CYAN}[*] Installing build dependencies...${NC}"
apt-get update -qq
apt-get install -y --no-install-recommends \
  live-build \
  debootstrap \
  xorriso \
  squashfs-tools \
  grub-pc-bin \
  grub-efi-amd64-bin \
  mtools \
  syslinux \
  isolinux \
  rsync \
  git \
  curl \
  wget \
  ca-certificates \
  gnupg

# ── FIX ALL PERMISSIONS ──────────────────────────────────────────
echo -e "${CYAN}[*] Fixing all script permissions...${NC}"
chmod +x BUILD.sh START.sh WRITE-USB.sh 2>/dev/null || true
chmod +x auto/config auto/build auto/clean
find config/hooks -name "*.chroot" -exec chmod +x {} \; 2>/dev/null || true
find config/hooks -name "*.live"   -exec chmod +x {} \; 2>/dev/null || true
echo -e "${CYAN}[✓] Permissions OK${NC}"

# ── CLEAN PREVIOUS BUILD ─────────────────────────────────────────
echo -e "${CYAN}[*] Cleaning previous build...${NC}"
lb clean --purge 2>/dev/null || true

# ── CONFIGURE ────────────────────────────────────────────────────
echo -e "${CYAN}[*] Configuring build...${NC}"
./auto/config

# ── BUILD ────────────────────────────────────────────────────────
echo -e "${CYAN}[*] Starting ISO build (this takes 2-4 hours)...${NC}"
echo -e "${RED}    DO NOT INTERRUPT${NC}"
echo ""

START=$(date +%s)
lb build 2>&1 | tee build.log
END=$(date +%s)
ELAPSED=$(( END - START ))

# ── RESULT ───────────────────────────────────────────────────────
if ls *.iso 2>/dev/null | head -1; then
  ISO=$(ls *.iso | head -1)
  SIZE=$(du -sh "$ISO" | awk '{print $1}')
  echo ""
  echo -e "${BRED}╔══════════════════════════════════════════╗"
  echo -e "║     BUILD COMPLETE — ANON-IRAN OS v7.0   ║"
  echo -e "╚══════════════════════════════════════════╝${NC}"
  echo -e "  ${CYAN}ISO:${NC}     $ISO"
  echo -e "  ${CYAN}Size:${NC}    $SIZE"
  echo -e "  ${CYAN}Time:${NC}    ${ELAPSED}s ($(( ELAPSED/60 )) min)"
  echo ""
  echo -e "  ${CYAN}Write to USB:${NC}"
  echo -e "  ${RED}sudo dd if=$ISO of=/dev/sdX bs=4M status=progress oflag=sync${NC}"
  echo ""
  echo -e "  ${CYAN}Test in QEMU:${NC}"
  echo -e "  ${RED}qemu-system-x86_64 -m 4096 -cdrom $ISO -boot d${NC}"
else
  echo -e "${RED}[!] Build failed — check build.log${NC}"
  exit 1
fi
