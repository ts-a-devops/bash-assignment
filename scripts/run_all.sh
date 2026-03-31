#!/bin/bash
set -euo pipefail

LOG_FILE="logs/app.log"

run_all() {
    bash scripts/user_info.sh
    bash scripts/system_check.sh
    bash scripts/backup.sh
}

menu() {
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
}

while true; do
    menu
    read -p "Choose option: " choice

    case $choice in
        1)
            run_all
            echo "$(date): Ran all scripts" >> "$LOG_FILE"
            ;;
        2)
            bash scripts/system_check.sh
            ;;
        3)
            bash scripts/backup.sh
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
