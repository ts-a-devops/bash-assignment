#!/bin/bash
set -euo pipefail

mkdir -p logs
log_file="logs/app.log"

log_exec() {
    echo "-----------------------------------" | tee -a "$log_file"
    echo "$(date): Executing $1..." | tee -a "$log_file"
    if ./scripts/"$1"; then
        echo "$(date): $1 completed successfully." | tee -a "$log_file"
    else
        echo "$(date): ERROR - $1 failed!" | tee -a "$log_file"
    fi
}

show_menu() {
    echo "================================="
    echo "   DevOps Toolkit Main Menu"
    echo "================================="
    echo "1. Run all scripts"
    echo "2. System check"
    echo "3. Backup a directory"
    echo "4. Run User Info alone"
    echo "5. Exit"
    echo "================================="
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            log_exec "user_info.sh"
            log_exec "system_check.sh"
            ;;
        2)
            log_exec "system_check.sh"
            ;;
        3)
            read -p "Enter the directory path to backup: " target_dir
            # Temporarily disable 'set -u' in case backup.sh expects specific args we aren't passing perfectly
            set +u 
            echo "$(date): Executing backup.sh..." | tee -a "$log_file"
            ./scripts/backup.sh "$target_dir" | tee -a "$log_file" || echo "Backup failed" | tee -a "$log_file"
            set -u
            ;;
        4)
            log_exec "user_info.sh"
            ;;
        5)
            echo "Exiting toolkit. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please run the script again."
            ;;
    esac
}

show_menu
