#!/bin/bash
# Best practice: Exit on error, unset variables, or pipe failures
set -euo pipefail

LOG="../logs/app.log"
mkdir -p ../logs

# Functions to organize logic
log_action() {
    echo "[$(date)] ACTION: $1" >> "$LOG"
}

show_menu() {
    echo "------------------------------------------"
    echo "   BASH ASSIGNMENT TOOLKIT - MAIN MENU    "
    echo "------------------------------------------"
    echo "1. Run All Scripts"
    echo "2. System Check"
    echo "3. Backup Scripts Folder"
    echo "4. Exit"
    echo "------------------------------------------"
    read -p "Choose an option [1-4]: " choice
}

# Main Logic Loop
while true; do
    show_menu
    case $choice in
        1)
            echo "Running all monitoring scripts..."
            ./users_info.sh
            ./system_check.sh
            ./process_monitor.sh
            log_action "Executed Run All"
            ;;
        2)
            ./system_check.sh
            log_action "Executed System Check"
            ;;
        3)
            ./backup.sh .
           log_action "Executed Backup"
            ;;
        4)
            log_action "Exited Toolkit"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    echo -e "\nPress Enter to return to menu..."
    read
done
