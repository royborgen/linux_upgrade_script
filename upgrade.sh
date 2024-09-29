#!/bin/sh
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'
echo "${CYAN}Checking APT:${NOCOLOR}"
sudo apt update && sudo apt upgrade -y
echo ""
echo "${CYAN}Checking Snap:${NOCOLOR}"
sudo snap refresh
echo ""
echo "${CYAN}Checking Flatpak:${NOCOLOR}"
flatpak upgrade --noninteractive
echo ""
test -e /var/run/reboot-required && echo "${YELLOW}Reboot is required!${NOCOLOR}"
