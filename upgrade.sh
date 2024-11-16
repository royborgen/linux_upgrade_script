#!/bin/sh

#setting text color
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

if [ $# -ne 0 ]; then
	if [ $1 = "-h" ] || [ $1 = "--help" ]; then
		echo "Usage: upgrade [OPTION]"
		echo "Performs system updates for packages managed by APT, Snap, and Flatpak on a Linux systems."
		echo ""
		echo "Optional arguments:"
		echo "-y, --yes          does not prompt before applying updates"
		echo "-h, --help         displays this message"
		
	fi 
fi

#checking if apt is installed before upgrading packages
if [ ! -z $(whereis apt | awk '{ print $2 }') ]; then
	echo "${CYAN}Checking APT:${NOCOLOR}"
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "--yes" ]; then
			sudo apt update && sudo apt upgrade -y
		fi
	else
		sudo apt update && sudo apt upgrade
	fi
	echo ""
	echo ""
fi

#checking if snap is installed before trying to upgrade packages
if [ ! -z $(whereis snap | awk '{ print $2 }') ]; then
	echo "${CYAN}Checking Snap:${NOCOLOR}"
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "--yes" ]; then
			sudo snap refresh 
			echo ""
		fi
	else
		updates=$(sudo snap refresh --list)  
		
		# Check if there are updates
		if [ ! -z "$updates" ]; then
		    echo "$updates"
		else
		    read -p "Do you want to install these updates? (Y/n): " confirm
		    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ] || [ -z "$confirm" ]; then
			# If user confirms, perform the update
			sudo snap refresh
		    else
			echo "Snap upgrade cancelled."
		    fi
		fi

		echo ""
	fi
fi


#checking if flatpak is installed before trying to upgrade packages
if [ ! -z $(whereis flatpak | awk '{ print $2 }') ]; then
	echo "${CYAN}Checking Flatpak:${NOCOLOR}"
	
	#checking if argument was provided
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "-yes" ]; then
			flatpak upgrade --noninteractive
		fi
	else
		flatpak upgrade
	fi

        echo ""
fi
#checking if restart is needed 
test -e /var/run/reboot-required && echo "${YELLOW}An update requires reboot!${NOCOLOR}" && echo ""
