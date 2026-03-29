#!/bin/bash

set -euo pipefail

LOG="logs/app.log"
mkdir -p logs

run_all() {
    bash scripts/user_info.sh
    bash scripts/system_check.sh
    bash scripts/file_manager.sh
    bash scripts/backup.sh
    bash scripts/process_monitor.sh
}

while true
do
    echo "====================="
    echo "   AUTOMATION MENU   "
    echo "====================="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    read -p "Choose an option: " CHOICE

    case $CHOICE in
        1) run_all >> "$LOG" 2>&1 ;;
        2) bash scripts/system_check.sh >> "$LOG" 2>&1 ;;
        3) read -p "Enter directory to backup: " DIR
           bash scripts/backup.sh "$DIR" >> "$LOG" 2>&1 ;;
        4) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
