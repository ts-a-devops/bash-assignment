#!/bin/bash

set -euo pipefail

# Ensure logs directory exists
mkdir -p logs
LOG_FILE="logs/app.log"

# Logging function
log_action() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

#Function for running system check
run_system_check() {
    echo "Running system check..."
    if bash scripts/system_check.sh; then
        log_action "SYSTEM CHECK - SUCCESS"
    else
        echo "System check failed."
        log_action "SYSTEM CHECK - FAILED"
    fi
}

#Function for running backup
run_backup() {
    read -p "Enter directory to backup: " dir

    if [[ -z "$dir" ]]; then
        echo "No directory provided."
        log_action "BACKUP - FAILED - No input"
        return
    fi

    echo "Running backup..."
    if bash scripts/backup.sh "$dir"; then
        log_action "BACKUP $dir - SUCCESS"
    else
        echo "Backup failed."
        log_action "BACKUP $dir - FAILED"
    fi
}

#Function for running all
run_all() {
    echo "Running all tasks..."
    log_action "RUN ALL - STARTED"

    run_system_check
    run_backup

    log_action "RUN ALL - COMPLETED"
}

# Menu loop
while true; do
    echo
    echo "===== MENU ====="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "================"

    read -p "Choose an option: " choice

    case "$choice" in
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
            log_action "APPLICATION EXIT"
            break
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done
