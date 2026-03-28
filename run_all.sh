#!/bin/bash


set -euo pipefail

mkdir -p logs
LOG_FILE="logs/app.log"

run_all() {
    echo "Running all scripts..." >> "$LOG_FILE"
    bash scripts/system_check.sh
    echo "All scripts executed." >> "$LOG_FILE"
}

system_check() {
    echo "Running system check..." >> "$LOG_FILE"
    bash scripts/system_check.sh
}

backup() {
    echo "Starting backup..." >> "$LOG_FILE"
    echo "Enter directory to backup:"
    read DIR
    bash scripts/backup.sh "$DIR"
    echo "Backup completed." >> "$LOG_FILE"
}

while true; do
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"

    read choice

    case $choice in
        1) run_all ;;
        2) system_check ;;
        3) backup ;;
        4) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
