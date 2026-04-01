#!/bin/bash
# run_all.sh - Interactive menu to run all DevOps toolkit scripts (Bonus)

set -euo pipefail

LOG_DIR="$(dirname "$0")/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/app.log"

SCRIPT_DIR="$(dirname "$0")/scripts"

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

run_user_info() {
    echo ""
    log_action "Running user_info.sh"
    bash "$SCRIPT_DIR/user_info.sh" || {
        echo "⚠️  user_info.sh encountered an error."
        log_action "user_info.sh failed."
    }
}

run_system_check() {
    echo ""
    log_action "Running system_check.sh"
    bash "$SCRIPT_DIR/system_check.sh" || {
        echo "⚠️  system_check.sh encountered an error."
        log_action "system_check.sh failed."
    }
}

run_backup() {
    echo ""
    read -rp "Enter the directory you want to back up: " BACKUP_TARGET
    log_action "Running backup.sh on '$BACKUP_TARGET'"
    bash "$SCRIPT_DIR/backup.sh" "$BACKUP_TARGET" || {
        echo "⚠️  backup.sh encountered an error."
        log_action "backup.sh failed."
    }
}

run_all_scripts() {
    echo ""
    echo "--- Running ALL scripts ---"
    log_action "Running ALL scripts"
    run_user_info
    run_system_check
    run_backup
    echo ""
    echo "✅ All scripts completed."
    log_action "All scripts completed."
}

show_menu() {
    echo ""
    echo "==============================="
    echo "    DEVOPS BASH TOOLKIT MENU   "
    echo "==============================="
    echo "  1. Run All Scripts"
    echo "  2. System Check"
    echo "  3. Backup a Directory"
    echo "  4. Exit"
    echo "==============================="
    read -rp "Select an option [1-4]: " CHOICE
}

# Main loop
log_action "run_all.sh started"

while true; do
    show_menu
    case "$CHOICE" in
        1) run_all_scripts ;;
        2) run_system_check ;;
        3) run_backup ;;
        4)
            echo ""
            echo "Goodbye! 👋"
            log_action "run_all.sh exited by user."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1, 2, 3, or 4."
            ;;
    esac
done
