#!/bin/bash
set -euo pipefail

mkdir -p logs
LOG_FILE="logs/app.log"

system_check() {
    echo "Running system_check.sh..." | tee -a "$LOG_FILE"
    ./scripts/system_check.sh
}

backup() {
    read -p "Enter directory to backup: " DIR
    echo "Running backup.sh for $DIR..." | tee -a "$LOG_FILE"
    ./scripts/backup.sh "$DIR"
}

run_all() {
    system_check
    backup
    echo "All tasks completed." | tee -a "$LOG_FILE"
}

while true; do
    echo "===================="
    echo "DevOps Bash Toolkit"
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "===================="

    read -p "Enter choice [1-4]: " choice

    case $choice in
        1) run_all ;;
        2) system_check ;;
        3) backup ;;
        4) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice, try again." ;;
    esac   # <- this MUST be here
done  # <- and this must close the while loop
