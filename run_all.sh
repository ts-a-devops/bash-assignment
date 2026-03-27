#!/bin/bash
# run_all.sh
set -euo pipefail # Best practice: Exit on error, unset variables, or pipe failures
LOG="logs/app.log"
mkdir -p logs

log_msg() { echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG"; }

show_menu() {
    echo -e "\n=============================="
    echo "   DEVOP BASH TOOLKIT MENU"
    echo "=============================="
    echo "1) Run User Info Script"
    echo "2) Run System Health Check"
    echo "3) Run Backup"
    echo "4) Run Process Monitor"
    echo "5) Exit"
    echo -e "==============================\n"
}

while true; do
    show_menu
    read -p "Choose an option [1-5]: " choice
    
    case $choice in
        1) log_msg "User selected User Info"; ./scripts/user_info.sh ;;
        2) log_msg "User selected System Check"; ./scripts/system_check.sh ;;
        3) 
            read -p "Enter directory to backup: " dir
            log_msg "User selected Backup for $dir"
            ./scripts/backup.sh "$dir" 
            ;;
        4) log_msg "User selected Process Monitor"; ./scripts/process_monitor.sh ;;
        5) echo "Exiting... Goodbye!"; log_msg "Application Exit"; exit 0 ;;
        *) echo "Invalid option, please try again." ;;
    esac
done
