#!/bin/bash

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"
SCRIPTS_DIR="./scripts"

mkdir -p "$LOG_DIR"

# -------------------------
# Logging function
# -------------------------
log() {
    echo "$(date '+%F %T') - $1" | tee -a "$LOG_FILE"
}

# -------------------------
# Error handler
# -------------------------
handle_error() {
    log "ERROR: Script failed at line $1"
}
trap 'handle_error $LINENO' ERR

# -------------------------
# Functions
# -------------------------

run_all() {
    log "Running all scripts..."

    run_system_check
    run_backup

    log "All tasks completed"
}

run_system_check() {
    log "Running system check..."

    if [[ -x "$SCRIPTS_DIR/process_monitor.sh" ]]; then
        "$SCRIPTS_DIR/process_monitor.sh" nginx ssh docker \
            >> "$LOG_FILE" 2>&1 || log "process_monitor failed"
    else
        log "process_monitor.sh not found or not executable"
    fi
}

run_backup() {
    log "Running backup..."

    read -p "Enter directory to backup: " dir

    if [[ -x "$SCRIPTS_DIR/backup.sh" ]]; then
        "$SCRIPTS_DIR/backup.sh" "$dir" \
            >> "$LOG_FILE" 2>&1 || log "backup failed"
    else
        log "backup.sh not found or not executable"
    fi
}

# -------------------------
# Menu
# -------------------------
PS3="Choose an option: "

select option in "Run All" "System Check" "Backup" "Exit"; do
    case $REPLY in
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
            log "Exiting application"
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
