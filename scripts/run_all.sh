#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$LOG_FILE"
}

run_with_handling() {
    local label="$1"
    shift
    if "$@"; then
        log "SUCCESS - $label"
    else
        log "ERROR - $label failed"
        echo "The action '$label' failed, but the application is still running."
    fi
}

run_system_check() {
    run_with_handling "System check" bash "$PROJECT_ROOT/scripts/system_check.sh"
}

run_backup() {
    read -r -p "Enter directory to back up: " backup_dir
    run_with_handling "Backup" bash "$PROJECT_ROOT/scripts/backup.sh" "$backup_dir"
}

run_all() {
    run_system_check
    run_backup
}

show_menu() {
    echo ""
    echo "==== DevOps Bash Toolkit ===="
    echo "1) Run all"
    echo "2) System check"
    echo "3) Backup"
    echo "4) Exit"
}

while true; do
    show_menu
    read -r -p "Choose an option: " choice
    case "$choice" in
        1)
            log "MENU - Run all selected"
            run_all
            ;;
        2)
            log "MENU - System check selected"
            run_system_check
            ;;
        3)
            log "MENU - Backup selected"
            run_backup
            ;;
        4)
            log "MENU - Exit selected"
            echo "Goodbye."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1-4."
            ;;
    esac
done
