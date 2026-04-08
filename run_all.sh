#!/bin/bash
set -euo pipefail

# 1. Functions for the menu
show_menu() {
    echo "---------------------------"
    echo " DEVOPS TOOLKIT MASTER MENU"
    echo "---------------------------"
    echo "1) Run User Info Script"
    echo "2) Run System Check"
    echo "3) Run Backup"
    echo "4) Exit"
    echo "---------------------------"
}

# 2. Main Loop
while true; do
    show_menu
    read -p "Choose an option [1-4]: " choice

    case $choice in
        1)
            ./scripts/user_info.sh
            ;;
        2)
            ./scripts/system_check.sh
            ;;
        3)
            read -p "Enter directory to backup: " dir
            ./scripts/backup.sh "$dir"
            ;;
        4)
            echo "Exiting Master Menu. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
