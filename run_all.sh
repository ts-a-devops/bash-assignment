#!/bin/bash

# run_all.sh - Simple menu

set -euo pipefail

LOG_FILE="logs/app.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

run() {
    if [[ -f "scripts/$1" ]]; then
        log "Running: $1"
        bash "scripts/$1"
        log "Finished: $1"
    else
        log "ERROR: scripts/$1 not found"
        echo "Error: scripts/$1 not found"
    fi
}

while true; do
    clear
    echo "=== Main Menu ==="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo
    read -rp "Choose [1-4]: " choice

    case $choice in
        1)
            log "Starting Run all"
            run "system_check.sh"
            run "backup.sh"
            echo "All done."
            read -rp "Press Enter to continue..."
            ;;
        2)
            run "system_check.sh"
            read -rp "Press Enter to continue..."
            ;;
        3)
            run "backup.sh"
            read -rp "Press Enter to continue..."
            ;;
        4)
            log "Exiting"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Try again."
            sleep 1
            ;;
    esac
done
