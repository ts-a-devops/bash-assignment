#!/bin/bash

# The safety flags: 
# -e (exit on error), -u (error on unset variables), -o pipefail (catch pipe errors)
set -euo pipefail

# Paths nd Logging
SCRIPTS_DIR="./scripts"
LOG_FILE="./logs/app.log"
mkdir -p ./logs

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# The functions
run_system_check() {
    echo "Starting System Health Check..."
    log_action "Started System Check"
    # Calling your user info/disk check script
    bash "$SCRIPTS_DIR/user_info.sh" || echo "System check encountered an error."
}

run_backup() {
    read -p "Enter directory to backup: " dir
    log_action "Backup initiated for $dir"
    bash "$SCRIPTS_DIR/backup.sh" "$dir" || echo "Backup failed."
}

run_all() {
    run_system_check
    run_backup
    # Add your service monitor here too
    bash "$SCRIPTS_DIR/monitor.sh"
}

# the interactive Menu
while true; do
    echo -e "\n=============================="
    echo "      MASTER CONTROL MENU"
    echo "=============================="
    echo "1. Run All Scripts"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    read -p "Choose an option [1-4]: " choice

    case $choice in
        1) run_all ;;
        2) run_system_check ;;
        3) run_backup ;;
        4) 
            echo "Valar Morghulis."
            log_action "User exited menu"
            exit 0 
            ;;
        *) 
            echo "Invalid option. Please try again." 
            ;;
    esac
done

