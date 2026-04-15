#!/bin/bash

set -euo pipefail

LOG_FILE="./logs/app.log"

function system_check() {
    bash scripts/system_check.sh
}

function backup() {
    read -p "Enter directory to backup: " dir
    bash scripts/backup.sh "$dir"
}

while true; do
    echo "1. System Check"
    echo "2. Backup"
    echo "3. Exit"

    read -p "Choose option: " choice

    case $choice in
        1) system_check ;;
        2) backup ;;
        3) exit 0 ;;
        *) echo "Invalid option" ;;
    esac

    echo "$(date): Selected $choice" >> "$LOG_FILE"
done
