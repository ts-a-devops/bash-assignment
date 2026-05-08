#!/bin/bash

set -euo pipefail

# Directories
SCRIPT_DIR="scripts"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

# Logging function
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Error handler
handle_error() {
    echo "An error occurred. Check logs for details."
    log_action "ERROR: A script execution failed"
}

# Run a script safely
run_script() {
    local script_name="$1"

    if [ ! -f "$SCRIPT_DIR/$script_name" ]; then
        echo "Script $script_name not found in $SCRIPT_DIR"
        log_action "FAILED: $script_name not found"
        return 1
    fi

    echo "Running $script_name..."
    log_action "START: $script_name"

    if bash "$SCRIPT_DIR/$script_name"; then
        log_action "SUCCESS: $script_name completed"
    else
        log_action "FAILED: $script_name execution error"
        handle_error
    fi
}

# Menu functions
run_all() {
    echo "Running all tasks..."
    log_action "Selected: Run All"

    run_script "process_monitor.sh"
    run_script "backup.sh"
}

system_check() {
    echo "Running system check..."
    log_action "Selected: System Check"

    run_script "process_monitor.sh"
}

backup_task() {
    echo "Running backup..."
    log_action "Selected: Backup"

    read -p "Enter directory to backup: " dir
    if [ -z "$dir" ]; then
        echo "No directory provided."
        log_action "Backup failed - no directory input"
        return
    fi

    if bash "$SCRIPT_DIR/backup.sh" "$dir"; then
        log_action "Backup completed for $dir"
    else
        log_action "Backup failed for $dir"
        handle_error
    fi
}

# Main menu
while true; do
    echo "========================="
    echo "   SYSTEM MENU"
    echo "========================="
    echo "1) Run all"
    echo "2) System check"
    echo "3) Backup"
    echo "4) Exit"
    echo "========================="

    read -p "Choose an option: " choice

    case "$choice" in
        1)
            run_all
            ;;
        2)
            system_check
            ;;
        3)
            backup_task
            ;;
        4)
            echo "Exiting..."
            log_action "Application exited"
            exit 0
            ;;
        *)
            echo "Invalid option. Try again."
            log_action "Invalid menu option selected"
            ;;
    esac

    echo ""
done
