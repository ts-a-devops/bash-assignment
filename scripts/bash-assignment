#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

run_system_check() {
    log "Running system check"
    ./system_check.sh
}

run_backup() {
    read -p "Enter directory to backup: " dir
    log "Running backup for $dir"
    ./backup.sh "$dir"
}

run_all() {
    log "Running all scripts"
    ./system_check.sh
    read -p "Enter directory to backup: " dir
    ./backup.sh "$dir"
}

while true; do
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    read -p "Choose an option: " choice

    case $choice in
        1) run_all ;;
        2) run_system_check ;;
        3) run_backup ;;
        4) log "Exiting"; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
