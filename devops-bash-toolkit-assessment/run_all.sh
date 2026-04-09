#!/bin/bash
set -euo pipefail
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"
SCRIPTS_DIR="scripts"
mkdir -p "$LOG_DIR"

# Function to log actions
log_action() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Function: Run all scripts
run_all() {
    log_action "Running all scripts..."
    bash "$SCRIPTS_DIR/system_check.sh" || log_action "system_check.sh failed"
    bash "$SCRIPTS_DIR/backup.sh" "$HOME" || log_action "backup.sh failed"
    bash "$SCRIPTS_DIR/process_monitor.sh" "nginx" || log_action "process_monitor.sh failed"
    log_action "Completed running all scripts"
}
# Function: System check
system_check() {
    log_action "Running system check..."
    if bash "$SCRIPTS_DIR/system_check.sh"; then
        log_action "system_check.sh completed successfully"
    else
        log_action "system_check.sh failed"
    fi
}

# Function: Backup
backup() {
    log_action "Running backup..."
    if bash "$SCRIPTS_DIR/backup.sh" "$HOME"; then
        log_action "backup.sh completed successfully"
    else
        log_action "backup.sh failed"
    fi
}

# Function: Exit
exit_script() {
    log_action "Exiting run_all.sh"
    exit 0
}

# Interactive menu
while true; do
    echo "============================"
    echo "   Run All Menu"
    echo "============================"
    echo "1) Run all"
    echo "2) System check"
    echo "3) Backup"
    echo "4) Exit"
    echo "============================"
    read -rp "Choose an option: " choice

    case $choice in
        1) run_all ;;
        2) system_check ;;
        3) backup ;;
        4) exit_script ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done

