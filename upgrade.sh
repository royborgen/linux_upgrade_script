#!/bin/bash

#setting text color
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

#setting variable to keep track if yay is installed to false by default
aur=false
arch=false

#setting variable for automatic yes flag
YES=false

#function to display usage/help
usage() {
    echo "Usage: $0 [OPTION]"
    echo "Performs package updates on Debian and Arch based distributions"
    echo "Upgrades APT, DNF, pacman, yay, snap, and Flatpak packages."
    echo ""
    echo "Optional arguments:"
    echo "-y, --yes          does not prompt before applying updates"
    echo "-h, --help         displays this message"
    echo ""
}

#function to run a command with optional yes flag
run_update() {
    local cmd="$1"
    local args="$2"
    if $YES; then
        eval "$cmd $args"
    else
        eval "$cmd"
    fi
}

#checking arguments and setting flags or displaying help
if [ $# -ne 0 ]; then
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -y|--yes)
            YES=true
            ;;
        *)
            echo "ERROR: Unsupported argument '$1'."
	    echo "Please use -h or --help to display usage instructions and valid options."
	    echo ""
            exit 1
            ;;
    esac
fi

#checking if apt is installed before upgrading packages
if command -v apt >/dev/null 2>&1; then
    echo -e "${CYAN}Checking APT:${NOCOLOR}"
    run_update "sudo apt update && sudo apt upgrade" "-y"
    echo ""
    echo ""
fi

#checking if yay is installed before upgrading packages
if command -v yay >/dev/null 2>&1; then
    #setting aur to true so we do not install upgrades from pacman
    aur=true
    arch=true
    echo -e "${CYAN}Checking yay:${NOCOLOR}"
    run_update "yay -Syu" "--noconfirm"
    echo ""
    echo ""
fi

#checking if pacman is installed before upgrading packages
if command -v pacman >/dev/null 2>&1 && [ "$aur" = false ]; then
    arch=true
    echo -e "${CYAN}Checking pacman:${NOCOLOR}"
    run_update "sudo pacman -Syu" "--noconfirm"
    echo ""
    echo ""
fi

#checking if DNF is installed before upgrading packages
if command -v dnf >/dev/null 2>&1; then
    echo -e "${CYAN}Checking DNF:${NOCOLOR}"
    run_update "sudo dnf upgrade" "-y"
    echo ""
fi

#checking if snap is installed before trying to upgrade packages
if command -v snap >/dev/null 2>&1; then
    echo -e "${CYAN}Checking Snap:${NOCOLOR}"
    if $YES; then
        sudo snap refresh
        echo ""
    else
        updates=$(sudo snap refresh --list)
        # Check if there are updates
        if [ -n "$updates" ]; then
            echo "$updates"
            read -p "Do you want to install these updates? (Y/n): " confirm
            confirm=${confirm:-Y}
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                sudo snap refresh
            else
                echo "Snap upgrade cancelled."
            fi
        fi
        echo ""
    fi
fi

#checking if flatpak is installed before trying to upgrade packages
if command -v flatpak >/dev/null 2>&1; then
    echo -e "${CYAN}Checking Flatpak:${NOCOLOR}"
    run_update "flatpak upgrade" "--noninteractive"
    echo ""
fi

# Checking if we got a new kernel on Arch
if [ "$arch" = true ] && command -v pacman >/dev/null 2>&1; then
    installed=$(pacman -Qe linux | awk '{print $2}')
    running=$(uname -r | sed 's/-arch/.arch/')
    if [ "$(vercmp "$installed" "$running")" -ne 0 ]; then
        echo -e "${YELLOW}A new kernel has been installed! Please reboot to start using it.${NOCOLOR}"
        echo ""
    fi
fi

#checking if restart is needed (Debian/Ubuntu)
test -e /var/run/reboot-required && echo -e "${YELLOW}An update requires reboot!${NOCOLOR}" && echo ""

