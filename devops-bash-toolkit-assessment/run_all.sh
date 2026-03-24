#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="logs/app.log"

# Ensure logs directory exists
mkdir -p logs

# Logging function
log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Error handler
handle_error() {
    log "ERROR: Script failed at line $1"
}

trap 'handle_error $LINENO' ERR

# Function to run system check
run_system_check() {
    log "Running system check..."
    if bash scripts/system_check.sh; then
        log "System check completed successfully."
    else
        log "System check failed."
    fi
}

# Function to run backup
run_backup() {
    read -p "Enter directory to back up: " dir
    log "Starting backup for $dir..."

    if bash scripts/backup.sh "$dir"; then
        log "Backup completed successfully."
    else
        log "Backup failed."
    fi
}

# Run all tasks
run_all() {
    log "Running all tasks..."

    run_system_check
    run_backup

    log "All tasks completed."
}

# Menu
while true; do
    echo ""
    echo "===== DevOps Toolkit Menu ====="
    echo "1) Run all"
    echo "2) System check"
    echo "3) Backup"
    echo "4) Exit"
    echo "==============================="

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
            log "Exiting application."
            exit 0
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done