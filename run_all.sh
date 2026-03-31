#!/bin/bash

set -euo pipefail

mkdir -p logs
LOG_FILE="logs/app.log"

run_system_check() {
    echo "Running system check..." | tee -a "$LOG_FILE"
    if ./scripts/system_check.sh; then
        echo "System check completed" | tee -a "$LOG_FILE"
    else
        echo "System check failed" | tee -a "$LOG_FILE"
    fi
}

run_backup() {
    read -p "Enter directory to back up: " dir
    echo "Running backup for $dir" | tee -a "$LOG_FILE"
    if ./scripts/backup.sh "$dir"; then
        echo "Backup completed" | tee -a "$LOG_FILE"
    else
        echo "Backup failed" | tee -a "$LOG_FILE"
    fi
}

run_all() {
    run_system_check
    run_backup
}

while true; do
    echo ""
    echo "===== DevOps Bash Toolkit ====="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "==============================="
    read -p "Choose an option [1-4]: " choice

    case "$choice" in
        1) run_all ;;
        2) run_system_check ;;
        3) run_backup ;;
        4) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option" | tee -a "$LOG_FILE" ;;
    esac
done
