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
		
		exit 
	fi 
fi

#checking if apt is installed before upgrading packages
if [ -e /usr/bin/apt ]; then
	echo "${CYAN}Checking APT:${NOCOLOR}"
	sudo apt update && sudo apt upgrade $1
	echo ""
fi

#checking if snap is installed before trying to upgrade packages
if [ -e /usr/bin/snap ]; then
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "-yes" ]; then
			echo "${CYAN}Checking Snap:${NOCOLOR}"
			sudo snap refresh 
			echo ""
		fi
	else
		updates=$(sudo snap refresh --list)

		# Check if there are updates
		if [ -z "$updates" ]; then
		    echo "All snaps up to date."
		else
		    # If updates are available, prompt for confirmation
		    echo "$updates"
		    read -p "Do you want to install these updates? (Y/n): " confirmation

		    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ] || "$confirmation" == "" ]; then
			# If user confirms, perform the update
			sudo snap refresh
		    else
			echo "Updates cancelled."
		    fi
		fi

		echo ""
	fi
fi


#checking if flatpak is installed before trying to upgrade packages
if [ -e /usr/bin/flatpak ]; then
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
