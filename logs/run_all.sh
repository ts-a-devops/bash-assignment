#!/bin/bash

# Strict mode
set -euo pipefail

# === Setup ===
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"
SCRIPTS_DIR="scripts"

mkdir -p "$LOG_DIR"

# === Logging function ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# === Functions ===

run_all() {
    log "Running all scripts..."

    bash "$SCRIPTS_DIR/system_check.sh"
    bash "$SCRIPTS_DIR/backup.sh" /home/user/projects

    log "Completed running all scripts."
}

system_check() {
    log "Running system check..."

    bash "$SCRIPTS_DIR/system_check.sh"

    log "System check completed."
}

backup() {
    read -p "Enter directory to backup: " dir

    log "Starting backup for $dir"

    bash "$SCRIPTS_DIR/backup.sh" "$dir"

    log "Backup completed for $dir"
}

# === Menu ===
while true; do
    echo ""
    echo "===== MENU ====="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "================"

    read -p "Choose an option: " choice

    case "$choice" in
        1) run_all ;;
        2) system_check ;;
        3) backup ;;
        4) log "Exiting application."; exit 0 ;;
        *) echo "Invalid option. Try again." ;;
    esac
done
