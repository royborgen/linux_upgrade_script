# Linux System Update Script

This script performs system updates on Linux by updating APT (Debian-based package manager), Snap, and Flatpak packages with a single command. It checks if each package manager is installed on the system before attempting updates and provides options for non-interactive updates and help.

## Script Overview

The script performs the following functions:
1. **APT Updates**: Updates and upgrades packages managed by APT if it is installed. Prompts for confirmation unless `-y` option is provided. 
2. **Snap Updates**: Checks for Snap updates and prompts for confirmation unless `-y` option is provided.
3. **Flatpak Updates**: Checks for updates to Platpak packages if installed. Prompts user for confirmation unless `-y` option is provided.
4. **Reboot Notification**: Notifies if a system restart is required after updates.

## Usage

```bash
Usage: upgrade [OPTION]
Performs system updates for packages managed by APT, Snap, and Flatpak on a Linux systems.

Optional arguments:
-y, --yes          does not prompt before applying updates
-h, --help         displays this message
```

## Features
- Updates are grouped by package manager, with color-coded messages for each.
- Reboot requirement notices are highlighted in yellow if a restart is needed.

## Requirements
- APT, Snap, or Flatpak installed (any or all of them).
- Root Privileges: The script automatically execute needed commands with sudo to perform updates.
- Non-interactive Mode: Use -y to skip prompts, useful for automated environments.

## License
This project is open-source and distributed under the MIT License.
