# Linux System Update Script


This script streamlines package updates for both Debian- and Arch-based Linux distributions. With a single command, it updates all system packages. It checks if each package manager is installed on the system before attempting updates and provides options for non-interactive updates and help. 

**Supported package managers:** APT, Pacman, Yay, Flatpak, and Snap. 


## Script Overview

The script performs the following functions:
1. **APT updates**: Runs sudo and updates and upgrades packages managed by APT if it is installed. Prompts for confirmation unless `-y` option is provided. User will be prompted for sudo password. 
2. **pacman updates**: Runs sudo, syncronizes and updates all packages managed by pacman if installed. Prompts for confirmations unless `-y` or `--yes` is provided. 
2. **yay updates**: Synchronizes and updates all packages managed by pacman if installed. Prompts for confirmations unless `-y` or `--yes` is provided. 
5. **Snap updates**: Runs sudo and checks for Snap updates and prompts for confirmation unless `-y` or `--yes` option is provided.
6. **Flatpak updates**: Checks for updates to Platpak packages if installed. Prompts user for confirmation unless `-y` or `--yes` option is provided.
7. **Reboot Notification**: Notifies if a system restart is required after updates.

## Usage

```
Usage: upgrade [OPTION]
Performs package updates on Debian and Arch based distributions
by updating APT, pacman, yay, snap, and Flatpak packages.

Optional arguments:
-y, --yes          does not prompt before applying updates
-h, --help         displays this message
```

## Features
- Updates are grouped by package manager, with color-coded section headings for each.
- Reboot requirement notices are highlighted in yellow if a restart is needed.

## Requirements
- APT, Snap, or Flatpak installed (any or all of them).
- Root Privileges: The script automatically execute needed commands with sudo to perform updates.
- Non-interactive Mode: Use -y to skip prompts, useful for automated environments.

## License
This project is open-source and distributed under the GPL-2.0 license 
