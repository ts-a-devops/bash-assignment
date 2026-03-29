#!/bin/bash

set -uo pipefail

# Get base directory (important fix):
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$BASE_DIR/devops-bash-toolkit-assestment/scripts"
LOG_DIR="$BASE_DIR/devops-bash-toolkit-assestment/logs"
LOG_FILE="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# -------- FUNCTIONS -------- #

run_user_info() {
    if ! "$SCRIPT_PATH/user_info.sh"; then
        echo "user_info failed"
        log "user_info.sh failed"
    fi
}

run_system_check() {
    if ! "$SCRIPT_PATH/system_check.sh"; then
        echo "system_check failed"
        log "system_check.sh failed"
    fi
}

run_file_manager() {
    echo "====== File Manager ======"
    echo "1) Create file"
    echo "2) Delete file"
    echo "3) List files"
    echo "4) Rename file"
    read -p "Choose option [1-4]: " fm_choice

    case "$fm_choice" in
        1)
            read -p "Enter filename: " fname
            "$SCRIPT_PATH/file_manager.sh" create "$fname"
            ;;
        2)
            read -p "Enter filename: " fname
            "$SCRIPT_PATH/file_manager.sh" delete "$fname"
            ;;
        3)
            "$SCRIPT_PATH/file_manager.sh" list
            ;;
        4)
            read -p "Enter old filename: " oldname
            read -p "Enter new filename: " newname
            "$SCRIPT_PATH/file_manager.sh" rename "$oldname" "$newname"
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

run_backup() {
    read -p "Enter directory to backup: " dir

    if [[ ! -d "$dir" ]]; then
        echo "Error: Directory does not exist"
        log "backup failed - invalid directory $dir"
        return
    fi

    if ! "$SCRIPT_PATH/backup.sh" "$dir"; then
        echo "backup failed"
        log "backup.sh failed for $dir"
    fi
}

run_process_monitor() {
    echo "Example: nginx ssh docker"
    read -p "Enter process names (or press Enter for defaults): " input

    if [[ -z "$input" ]]; then
        "$SCRIPT_PATH/process_monitor.sh"
    else
        "$SCRIPT_PATH/process_monitor.sh" $input
    fi
}

run_all() {
    log "Running all scripts"

    run_user_info
    run_system_check

    echo "Tip: use something like:"
    echo "devops-bash-toolkit-assestment/scripts"
    run_backup

    run_file_manager
    run_process_monitor
}

# -------- MENU -------- #

show_menu() {
    echo "=========================="
    echo " DevOps Bash Toolkit Menu"
    echo "=========================="
    echo "1) Run all scripts"
    echo "2) System Check"
    echo "3) Backup"
    echo "4) File Manager"
    echo "5) User Info"
    echo "6) Process Monitor"
    echo "7) Exit"
}

# -------- MAIN LOOP -------- #

while true; do
    show_menu
    read -p "Choose an option [1-7]: " choice

    case "$choice" in
        1) run_all ;;
        2) run_system_check ;;
        3) run_backup ;;
        4) run_file_manager ;;
        5) run_user_info ;;
        6) run_process_monitor ;;
        7)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
done

