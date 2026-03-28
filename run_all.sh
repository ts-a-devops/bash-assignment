#!/bin/bash

set -euo pipefail

# Create logs directory
mkdir -p logs

log_action() {
    echo "$1" | tee -a logs/app.log
}

run_all() {
    log_action "Running all scripts..."

    bash scripts/user_info.sh
    bash scripts/system_check.sh
    bash scripts/file_manager.sh list
    bash scripts/backup.sh .
    bash scripts/process_monitor.sh

    log_action "All scripts completed!"
}

system_check() {
    log_action "Running system check..."
    bash scripts/system_check.sh
}

backup() {
    log_action "Running backup..."
    bash scripts/backup.sh .
}

# Menu
while true; do
    echo ""
    echo "=== DevOps Bash Toolkit ==="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"

    read -p "Choose an option: " option

    case $option in
        1) run_all ;;
        2) system_check ;;
        3) backup ;;
        4) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option!" ;;
    esac
done
