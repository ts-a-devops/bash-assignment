#!/bin/bash

# 1. Strict Mode
# -e: Exit immediately if a command fails
# -u: Exit if an unset variable is used
# -o pipefail: Exit if any command in a pipeline fails
set -euo pipefail

# 2. Configuration
SCRIPT_DIR="./scripts"
LOG_FILE="logs/app.log"
mkdir -p logs

# 3. Functions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

run_system_check() {
    echo "--- Running System Check ---"
    bash "$SCRIPT_DIR/system_check.sh" || echo "System check failed!"
    log_action "Executed System Check"
}

run_backup() {
    read -p "Enter directory to backup: " dir
    echo "--- Running Backup ---"
    bash "$SCRIPT_DIR/backup.sh" "$dir" || echo "Backup failed!"
    log_action "Executed Backup on $dir"
}

run_all() {
    run_system_check
    # Note: Backup in 'run_all' might need a default directory or user input
    run_backup
}

# 4. Interactive Menu
while true; do
    echo "=============================="
    echo "      DEVOPS TOOLBOX"
    echo "=============================="
    echo "1) Run All Tasks"
    echo "2) System Check"
    echo "3) Backup Utility"
    echo "4) Exit"
    echo "=============================="
    read -p "Select an option [1-4]: " choice

    case $choice in
        1) run_all ;;
        2) run_system_check ;;
        3) run_backup ;;
        4) 
            echo "Exiting..."
            log_action "User exited menu"
            exit 0 
            ;;
        *) 
            echo "Invalid option. Please try again." 
            ;;
    esac
    echo -e "\nPress Enter to return to menu..."
    read
done
