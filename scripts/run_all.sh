#!/bin/bash
set -euo pipefail

#  Configuration 
SCRIPTS_DIR="$(dirname "$0")"
LOG_FILE="$(dirname "$0")/../logs/app.log"

#  Logging Function 
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Ensure logs directory exists 
mkdir -p "$(dirname "$LOG_FILE")"

#  Functions 
run_all() {
    log_message "INFO: Running all scripts"

    run_system_check
    run_backup
    run_process_monitor

    log_message "INFO: All scripts completed"
}

run_system_check() {
    log_message "INFO: Running system_check.sh"
    if bash "$SCRIPTS_DIR/system_check.sh"; then
        log_message "SUCCESS: system_check.sh completed"
    else
        log_message "ERROR: system_check.sh failed"
        echo "Warning: system_check.sh encountered an error but continuing..."
    fi
}

run_backup() {
    log_message "INFO: Running backup.sh"
    echo ""
    read -rp "Enter directory to backup: " BACKUP_TARGET

    if bash "$SCRIPTS_DIR/backup.sh" "$BACKUP_TARGET"; then
        log_message "SUCCESS: backup.sh completed for '$BACKUP_TARGET'"
    else
        log_message "ERROR: backup.sh failed for '$BACKUP_TARGET'"
        echo "Warning: backup.sh encountered an error but continuing..."
    fi
}

run_process_monitor() {
    log_message "INFO: Running process_monitor.sh"
    echo ""
    read -rp "Enter process name to monitor: " PROCESS_NAME

    if bash "$SCRIPTS_DIR/process_monitor.sh" "$PROCESS_NAME"; then
        log_message "SUCCESS: process_monitor.sh completed for '$PROCESS_NAME'"
    else
        log_message "ERROR: process_monitor.sh failed for '$PROCESS_NAME'"
        echo "Warning: process_monitor.sh encountered an error but continuing..."
    fi
}

#  Menu 
show_menu() {
    echo ""
    echo "=============================="
    echo "       BASH ASSIGNMENT MENU   "
    echo "=============================="
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    echo "=============================="
    read -rp "Choose an option [1-4]: " CHOICE
}

#  Main Loop 
log_message "INFO: run_all.sh started"

while true; do
    show_menu

    case "$CHOICE" in
        1)
            log_message "INFO: User selected 'Run All'"
            run_all
            ;;
        2)
            log_message "INFO: User selected 'System Check'"
            run_system_check
            ;;
        3)
            log_message "INFO: User selected 'Backup'"
            run_backup
            ;;
        4)
            log_message "INFO: User selected 'Exit'"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            log_message "WARNING: Invalid option '$CHOICE' selected"
            echo "Invalid option. Please choose 1-4."
            ;;
    esac
done