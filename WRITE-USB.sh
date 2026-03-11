#!/bin/bash
# Write ANON-IRAN OS ISO to USB drive
RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'
[ "$EUID" -ne 0 ] && { echo "Run as root"; exit 1; }

ISO=$(ls *.iso 2>/dev/null | head -1)
[ -z "$ISO" ] && { echo "No ISO found. Run BUILD.sh first."; exit 1; }

echo -e "${RED}Available block devices:${NC}"
lsblk -d -o NAME,SIZE,MODEL | grep -v loop

read -p "Enter USB device (e.g. sdb, NOT sdb1): " DEV
DEV="/dev/${DEV}"

[ ! -b "$DEV" ] && { echo "Device $DEV not found"; exit 1; }

echo -e "${RED}[!] WARNING: All data on $DEV will be DESTROYED${NC}"
read -p "Confirm? Type YES: " CONFIRM
[ "$CONFIRM" != "YES" ] && { echo "Aborted"; exit 1; }

echo -e "${CYAN}[*] Writing $ISO to $DEV...${NC}"
dd if="$ISO" of="$DEV" bs=4M status=progress oflag=sync
sync
echo -e "${RED}[*] Done! ANON-IRAN OS written to $DEV${NC}"
