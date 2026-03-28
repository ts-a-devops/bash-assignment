#!/bin/bash
set -euo pipefail

# Ensure logs directory exists
mkdir -p logs

# Log file
log_file="logs/app.log"

# Function to log messages
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$log_file"
}

# Functions to call scripts from scripts/ directory
run_system_check() {
    log_action "Running system_check.sh..."
    if ./scripts/system_check.sh; then
        log_action "system_check.sh completed successfully."
    else
        log_action "system_check.sh failed."
    fi
}

run_backup() {
    log_action "Running backup.sh..."
    # Example: backup current folder
    if ./scripts/backup.sh .; then
        log_action "backup.sh completed successfully."
    else
        log_action "backup.sh failed."
    fi
}

run_all_scripts() {
    log_action "Running all scripts..."
    run_system_check
    run_backup
    log_action "All scripts completed."
}

# Interactive menu
while true; do
    echo ""
    echo "===== Bash Toolkit Menu ====="
    echo "1) Run All Scripts"
    echo "2) System Check"
    echo "3) Backup"
    echo "4) Exit"
    echo "============================="
    read -p "Enter your choice [1-4]: " choice

    case $choice in
        1)
            run_all_scripts
            ;;
        2)
            run_system_check
            ;;
        3)
            run_backup
            ;;
        4)
            log_action "Exiting run_all.sh."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1-4."
            ;;
    esac
done
