#!/bin/bash

#setting text color
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

#setting variable to keep track if yay is installed to 0 by default
foundyay=0


#Checking arguments and displaying help text and error message
if [ $# -ne 0 ]; then
	if [ $1 = "-h" ] || [ $1 = "--help" ]; then
		echo "Usage: upgrade [OPTION]"
		echo "Performs package updates on Debian and Arch based distributions"
		echo "Upgrades APT, DNF, pacman, yay, snap, and Flatpak packages."
		echo ""
		echo "Optional arguments:"
		echo "-y, --yes          does not prompt before applying updates"
		echo "-h, --help         displays this message"
		echo ""
		exit
	fi 
	
	if [ "$1" != "-y" ] && [ "$1" != "--yes" ]; then
		echo "ERROR: Unsupported argument '$1'."
		echo "Please use -h or --help to display usage instructions and valid options."
		echo ""
		exit
	fi 
fi

#checking if apt is installed before upgrading packages
if [ ! -z $(whereis apt | awk '{ print $2 }') ]; then
	echo -e "${CYAN}Checking APT:${NOCOLOR}"
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


#checking if yay is installed before upgrading packages
if [ ! -z $(whereis yay | awk '{ print $2 }') ]; then
	#setting foundyay to 1 so we do not install upgrades from pacman
	foundyay=1
	echo -e "${CYAN}Checking yay:${NOCOLOR}"
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "--yes" ]; then
			yay -Syu --noconfirm
		fi
	else
		yay -Syu
	fi
	echo ""
	echo ""
fi

#checking if pacman is installed before upgrading packages
if [ -n "$(whereis pacman | awk '{ print $2 }')" ] && [ "$foundyay" -eq 0 ]; then
	echo -e "${CYAN}Checking pacman:${NOCOLOR}"
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "--yes" ]; then
			sudo pacman -Syu --noconfirm
		fi
	else
		sudo pacman -Syu
	fi
	echo ""
	echo ""
fi


#checking if DNF is installed before upgrading packages
if [ ! -z $(whereis dnf | awk '{ print $2 }') ]; then
	echo -e "${CYAN}Checking DNF:${NOCOLOR}"
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "--yes" ]; then
			sudo dnf upgrade -y
		fi
	else
		sudo dnf upgrade
	fi
	echo ""
fi

#checking if snap is installed before trying to upgrade packages
if [ ! -z $(whereis snap | awk '{ print $2 }') ]; then
	echo -e "${CYAN}Checking Snap:${NOCOLOR}"
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "--yes" ]; then
			sudo snap refresh 
			echo ""
		fi
	else
		updates=$(sudo snap refresh --list)  
		
		# Check if there are updates
		if [ -n "$updates" ]; then
		    echo "$updates"
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
	echo -e "${CYAN}Checking Flatpak:${NOCOLOR}"
	
	#checking if argument was provided
	if [ $# -ne 0 ]; then
		if [ $1 = "-y" ] || [ $1 = "--yes" ]; then
			flatpak upgrade --noninteractive
		fi
	else
		flatpak upgrade
	fi

        echo ""
fi
#checking if restart is needed 
test -e /var/run/reboot-required && echo -e "${YELLOW}An update requires reboot!${NOCOLOR}" && echo ""
