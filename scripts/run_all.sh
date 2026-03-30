#!/bin/bash

set -euo pipefail

LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/app.log"
SCRIPTS_DIR="./"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

log_action() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

run_system_check() {
    log_action "Running system_check.sh"
    bash "$SCRIPTS_DIR/system_check.sh"
}

run_backup() {
    read -p "Enter directory to back up: " dir
    log_action "Running backup.sh on $dir"
    bash "$SCRIPTS_DIR/backup.sh" "$dir"
}

run_all() {
    log_action "Running all scripts"
    run_system_check
    run_backup
}

show_menu() {
    echo "=============================="
    echo "       SCRIPT MENU"
    echo "=============================="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "=============================="
}

while true; do
    show_menu
    read -p "Choose an option [1-4]: " choice

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
            log_action "Exiting application"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    echo ""
done
