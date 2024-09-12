#!/bin/sh
echo "Checking APT:"
sudo apt update && sudo apt upgrade -y 
echo ""
echo "Checking Snap:"
sudo snap refresh 
echo ""
echo "Checking Flatpak:"
flatpak upgrade --noninteractive
