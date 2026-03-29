#!/bin/bash

# Main interactive menu for DevOps Bash Toolkit
# Logs actions to logs/app.log

set -euo pipefail

LOG_FILE="logs/app.log"
mkdir -p logs

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - MENU_ACTION: $1" >> "$LOG_FILE"
}

show_menu() {
    echo "===================================="
    echo "   🚀 DevOps Bash Toolkit Menu"
    echo "===================================="
    echo "1) Run User Info Collection"
    echo "2) Run System Check"
    echo "3) File Manager"
    echo "4) Backup Directory"
    echo "5) Process Monitor"
    echo "6) Run All Scripts"
    echo "7) Exit"
    echo "===================================="
}

while true; do
    show_menu
    read -p "Select an option (1-7): " choice
    
    case $choice in
        1)
            log_action "User Info"
            ./scripts/user_info.sh
            ;;
        2)
            log_action "System Check"
            ./scripts/system_check.sh
            ;;
        3)
            log_action "File Manager"
            read -p "Enter action (create|delete|list|rename): " fm_action
            case $fm_action in
                create|delete|list)
                    read -p "Enter filename (if applicable): " fm_file
                    ./scripts/file_manager.sh "$fm_action" "$fm_file"
                    ;;
                rename)
                    read -p "Enter old filename: " fm_old
                    read -p "Enter new filename: " fm_new
                    ./scripts/file_manager.sh rename "$fm_old" "$fm_new"
                    ;;
                *)
                    echo "Invalid action."
                    ;;
            esac
            ;;
        4)
            log_action "Backup"
            read -p "Enter directory to backup: " backup_dir
            ./scripts/backup.sh "$backup_dir"
            ;;
        5)
            log_action "Process Monitor"
            ./scripts/process_monitor.sh
            ;;
        6)
            log_action "Run All"
            echo "Running all scripts..."
            ./scripts/user_info.sh
            ./scripts/system_check.sh
            ./scripts/process_monitor.sh
            ;;
        7)
            log_action "Exit"
            echo "Exiting. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    echo -e "\nPress Enter to continue..."
    read
done
