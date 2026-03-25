#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")/scripts"
LOG_DIR="$(dirname "$0")/logs"
APP_LOG="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$APP_LOG"
}

run_script() {
    local SCRIPT="$1"
    local LABEL="$2"
    shift 2
    local ARGS=("$@")

    echo ""
    echo "Running: $LABEL"
    log "Running: $LABEL"

    if bash "$SCRIPT_DIR/$SCRIPT" "${ARGS[@]:-}"; then
        echo "$LABEL: done."
        log "$LABEL: success"
    else
        echo "Warning: $LABEL exited with an error."
        log "$LABEL: failed"
    fi
}

show_menu() {
    clear
    echo "DevOps Bash Toolkit"
    echo "1) Run all scripts"
    echo "2) System check"
    echo "3) Backup"
    echo "4) Exit"
    echo ""
}

run_all() {
    run_script "system_check.sh" "System Check"
    run_script "process_monitor.sh" "Process Monitor"

    read -rp "Directory to backup [default: ./scripts]: " BACKUP_TARGET
    BACKUP_TARGET="${BACKUP_TARGET:-./scripts}"
    run_script "backup.sh" "Backup" "$BACKUP_TARGET"
}

system_check() {
    run_script "system_check.sh" "System Check"
}

backup_menu() {
    read -rp "Directory to backup: " BACKUP_TARGET
    [[ -z "$BACKUP_TARGET" ]] && { echo "No directory provided."; return; }
    run_script "backup.sh" "Backup" "$BACKUP_TARGET"
}

log "Session started"

while true; do
    show_menu
    read -rp "Choose an option [1-4]: " CHOICE

    case "$CHOICE" in
        1) run_all       ;;
        2) system_check  ;;
        3) backup_menu   ;;
        4) echo "Goodbye!"; log "Session ended"; exit 0 ;;
        *) echo "Invalid option: '$CHOICE'. Choose 1-4." ;;
    esac

    echo ""
    read -rp "Press [Enter] to return to menu..." _
done
