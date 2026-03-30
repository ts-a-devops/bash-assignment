#!/bin/bash

set -euo pipefail

mkdir -p logs

LOG_FILE="logs/app.log"

log() {
    echo "$(date): $1" >> $LOG_FILE
}

run_system_check() {
    echo "Running system check..."
    ./scripts/system_check.sh
    log "System check executed"
}

run_backup() {
    read -p "Enter directory to backup: " dir
    ./scripts/backup.sh "$dir"
    log "Backup executed for $dir"
}

run_all() {
    echo "Running all scripts..."
    ./scripts/system_check.sh
    ./scripts/user_info.sh
    log "All scripts executed"
}

while true; do
    echo "=========================="
    echo " DevOps Bash Toolkit Menu "
    echo "=========================="
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    echo "=========================="

    read -p "Choose an option: " choice

    case $choice in
        1) run_all ;;
        2) run_system_check ;;
        3) run_backup ;;
        4) echo "Exiting..."; log "App exited"; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done

