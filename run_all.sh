#!/bin/bash

# Professional Bash Safety Settings
set -euo pipefail

# Log all overall app actions
LOG_FILE="logs/app.log"
mkdir -p logs

show_menu() {
    echo "------------------------------------------"
    echo "   🚀 DEVOPS BASH TOOLKIT - MASTER MENU"
    echo "------------------------------------------"
    echo "1. Run User Info Collector"
    echo "2. Run System Health Check"
    echo "3. Run Backup (Scripts Folder)"
    echo "4. Run Process Monitor"
    echo "5. Exit"
    echo "------------------------------------------"
    read -p "Choose an option [1-5]: " choice
}

while true; do
    show_menu
    case $choice in
        1)
            ./scripts/user_info.sh
            echo "User Info completed." >> "$LOG_FILE"
            ;;
        2)
            ./scripts/system_check.sh
            echo "System Check completed." >> "$LOG_FILE"
            ;;
        3)
            ./scripts/backup.sh scripts
            echo "Backup of scripts completed." >> "$LOG_FILE"
            ;;
        4)
            ./scripts/process_monitor.sh
            echo "Process Monitor completed." >> "$LOG_FILE"
            ;;
        5)
            echo "Exiting. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    echo -e "\nPress Enter to return to menu..."
    read
done
