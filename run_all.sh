#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOG_FILE="$SCRIPT_DIR/logs/app.log"

function system_check() {
    bash "$SCRIPT_DIR/scripts/system_check.sh"
}

function backup() {
    read -p "Enter directory to backup: " dir
    bash "$SCRIPT_DIR/scripts/backup.sh" "$dir"
}

while true; do
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"

    read -p "Choose option: " choice

    case $choice in
        1)
            bash "$SCRIPT_DIR/scripts/user_info.sh"
            system_check
            echo "$(date): Ran all scripts" >> "$LOG_FILE"
            ;;
        2)
            system_check
            ;;
        3)
            backup
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
