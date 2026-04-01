#!/bin/bash
set -euo pipefail

LOG_FILE="../logs/app.log"

run_all() {
    bash scripts/file_manager.sh list
    bash scripts/system_check.sh
    bash scripts/backup.sh .
    bash scripts/process_monitor.sh
    bash scripts/user_info.sh
}

menu() {
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
}

while true; do
    menu
    read -p "Choose option: " choice
    case $choice in
        1) run_all | tee -a "$LOG_FILE" ;;
        2) bash scripts/system_check.sh | tee -a "$LOG_FILE" ;;
        3) bash scripts/backup.sh . | tee -a "$LOG_FILE" ;;
        4) echo "Exiting."; exit 0 ;;
        *) echo "Invalid option. Try again." ;;
    esac
done
