#!/bin/bash
set -euo pipefail

mkdir -p logs
LOG_FILE="logs/app.log"

run_all() {
    echo "Running all scripts..."

    ./scripts/user_info.sh || echo "user_info failed"
    ./scripts/system_check.sh || echo "system_check failed"
    ./scripts/process_monitor.sh || echo "process_monitor failed"

    echo "$(date): Ran all scripts" >> "$LOG_FILE"
}

system_check() {
    ./scripts/system_check.sh
    echo "$(date): Ran system check" >> "$LOG_FILE"
}

backup() {
    read -p "Enter directory to backup: " dir
    ./scripts/backup.sh "$dir" || echo "Backup failed"
    echo "$(date): Backup attempted for $dir" >> "$LOG_FILE"
}

menu() {
    echo ""
    echo "===== DevOps Toolkit ====="
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    echo "=========================="
}

while true; do
    menu
    read -p "Choose an option: " choice

    case $choice in
        1)
            run_all
            ;;
        2)
            system_check
            ;;
        3)
            backup
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done
