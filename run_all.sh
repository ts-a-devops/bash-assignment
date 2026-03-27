#!/bin/bash

set -euo pipefail

mkdir -p logs
log_file="logs/app.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

run_system_check() {
    echo "Running system check..."
    ./system_check.sh
    log_action "Ran system_check.sh"
}

run_backup() {
    read -p "Enter directory to backup: " dir
    ./backup.sh "$dir"
    log_action "Ran backup.sh on $dir"
}

run_all() {
    echo "Running all tasks..."

    ./system_check.sh
    log_action "Ran system_check.sh"

    read -p "Enter directory to backup: " dir
    ./backup.sh "$dir"
    log_action "Ran backup.sh on $dir"
}

while true; do
    echo ""
    echo "====== DEVOPS MENU ======"
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "========================="

    read -p "Choose an option: " choice

    case $choice in
        1)
            run_all
            ;;
        2)
            run_system_check
            ;;
        3)
            run_backup
            ;;
        4)
            echo "Exiting..."
            log_action "User exited application"
            exit 0
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done
