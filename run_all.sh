#!/bin/bash

set -euo pipefail

LOG_FILE="logs/app.log"
mkdir -p logs

run_all() {
    scripts/user_info.sh
    scripts/system_check.sh
    echo "Ran all scripts" >> $LOG_FILE
}

system_check() {
    scripts/system_check.sh
}

backup() {
    read -p "Enter directory to backup: " dir
    scripts/backup.sh "$dir"
}

while true
do
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"

    read -p "Choose option: " choice

    case $choice in
        1) run_all ;;
        2) system_check ;;
        3) backup ;;
        4) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
