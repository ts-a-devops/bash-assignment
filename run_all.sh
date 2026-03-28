#!/bin/bash
set -euo pipefail

mkdir -p logs

LOG_FILE="logs/app.log"

# Functions to call each script
run_user_info() {
    ./scripts/user_info.sh
    echo "$(date): user_info.sh ran" >> $LOG_FILE
}

run_system_check() {
    ./scripts/system_check.sh
    echo "$(date): system_check.sh ran" >> $LOG_FILE
}

run_backup() {
    read -p "Enter directory to backup: " DIR
    ./scripts/backup.sh "$DIR"
    echo "$(date): backup.sh ran for $DIR" >> $LOG_FILE
}

# Interactive menu
while true; do
    echo -e "\n=== DevOps Bash Toolkit Menu ==="
    echo "1) Run all"
    echo "2) System check"
    echo "3) Backup"
    echo "4) Exit"
    read -p "Choose an option [1-4]: " choice

    case $choice in
        1)
            run_user_info
            run_system_check
            run_backup
            ;;
        2) run_system_check ;;
        3) run_backup ;;
        4) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
