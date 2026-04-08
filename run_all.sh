#!/bin/bash
set -euo pipefail

# Ensure logs directory exists
mkdir -p logs
LOG_FILE="logs/app.log"

# Directory containing your scripts
SCRIPTS_DIR="scripts"

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Function to run system_check.sh
run_system_check() {
    local script="$SCRIPTS_DIR/system_check.sh"
    if [[ -x "$script" ]]; then
        log "Running system check..."
        "$script" || log "ERROR: system_check.sh failed"
    else
        log "ERROR: $script not found or not executable"
    fi
}

# Function to run backup.sh (if it exists)
run_backup() {
    local script="$SCRIPTS_DIR/backup.sh"
    if [[ -x "$script" ]]; then
        log "Running backup..."
        "$script" || log "ERROR: backup.sh failed"
    else
        log "WARNING: $script not found or not executable"
    fi
}

# Function to run all scripts
run_all() {
    log "Running all scripts..."
    run_system_check
    run_backup
    log "All scripts completed."
}

# Interactive menu
while true; do
    echo ""
    echo "===== DevOps Toolkit Menu ====="
    echo "1) Run all"
    echo "2) System check"
    echo "3) Backup"
    echo "4) Exit"
    read -p "Enter your choice [1-4]: " choice

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
            log "Exiting menu."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select 1-4."
            ;;
    esac
done
