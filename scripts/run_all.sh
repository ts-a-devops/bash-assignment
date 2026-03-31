#!/bin/bash
set -euo pipefail

# Ensure directories exist


LOG_FILE="../logs/app.log"

# Function: show menu
show_menu() {
    echo "===== bash_assignment ====="
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
}

# Function: run all scripts
run_all() {
    bash user_info.sh
    bash system_check.sh
}

# Function: system check
run_system_check() {
    bash system_check.sh
}

# Function: backup
run_backup() {
    read -p "Enter directory to backup: " dir
    bash scripts/backup.sh "$dir" 
}

# Main loop
while true; do
    show_menu
    read -p "Choose an option: " choice

    case $choice in
        1)
            run_all
            ;;
        2)
            run_system_check
            ;;
        3)
            run_backup
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac

    # Log user action
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Selected option $choice" >> "$LOG_FILE"
done
