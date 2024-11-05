#!/bin/sh

#setting text color
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

#checking if apt is installed before upgrading packages
if [ -e /usr/bin/apt ]; then
	echo "${CYAN}Checking APT:${NOCOLOR}"
	sudo apt update && sudo apt upgrade -y 
	echo ""
fi

#checking if snap is installed before trying to upgrade packages
if [ -e /usr/bin/snap ]; then
	echo "${CYAN}Checking Snap:${NOCOLOR}"
	sudo snap refresh 
	echo ""
fi

if [ -e /usr/bin/flatpak ]; then
	echo "${CYAN}Checking Flatpak:${NOCOLOR}"
	flatpak upgrade --noninteractive
        echo ""
fi
#checking if restart is needed 
test -e /var/run/reboot-required && echo "${YELLOW}An update requires reboot!${NOCOLOR}" && echo ""
