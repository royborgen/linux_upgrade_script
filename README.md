# Linux Update Script

This script performs system updates for packages managed by APT, Snap, and Flatpak on a Unix-based system. It ensures that your system's software packages are up-to-date by running the appropriate update commands for each package manager.

## Features

- **APT Update**: Updates and upgrades packages managed by APT.
- **Snap Refresh**: Refreshes Snap packages.
- **Flatpak Upgrade**: Upgrades Flatpak packages without user interaction.

## Usage

1. **Make the script executable**:
   ```
   chmod +x update_script.sh
   ```
2. Run the script:
`./upgrade.sh`

## Requirements
* Debian based Linux distribution
* snap package manager installed
* flatpak package manager installed
