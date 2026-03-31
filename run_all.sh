#!/bin/bash

set -uo pipefail
shopt -s extglob

# ----------------- BASE SETUP ----------------- #
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$BASE_DIR/devops-bash-toolkit-assestment/scripts"
LOG_DIR="$BASE_DIR/devops-bash-toolkit-assestment/logs"
mkdir -p "$LOG_DIR"
APP_LOG="$LOG_DIR/app.log"

log() {
    echo "$(date): $1" >> "$APP_LOG"
}

# ----------------- FUNCTIONS ----------------- #

# User Info
run_user_info() {
    echo "====== Running User Info ======"
    USER_LOG="$LOG_DIR/user_info.log"
    if ! bash "$SCRIPTS_DIR/user_info.sh" "$USER_LOG"; then
        echo "user_info.sh failed"
        log "user_info.sh failed"
    else
        log "user_info.sh executed successfully"
    fi
}

# System Check
run_system_check() {
    echo "====== Running System Check ======"
    SYSTEM_LOG="$LOG_DIR/system_report.log/system_report_$(date +%Y-%m-%d_%H-%M-%S).log"
    if ! bash "$SCRIPTS_DIR/system_check.sh" "$SYSTEM_LOG"; then
        echo "system_check.sh failed"
        log "system_check.sh failed"
    else
        log "system_check.sh executed successfully, saved to $SYSTEM_LOG"
    fi
}

# File Manager
run_file_manager() {
    echo "====== File Manager ======"
    echo "1) Create file(s)"
    echo "2) Delete file(s)"
    echo "3) List files"
    echo "4) Rename file"
    read -p "Choose option [1-4]: " fm_choice

    case "$fm_choice" in
        1)
            read -p "Enter filenames (space separated): " -a files
            bash "$SCRIPTS_DIR/file_manager.sh" create "${files[@]}"
            ;;
        2)
            read -p "Enter filenames (space separated): " -a files
            bash "$SCRIPTS_DIR/file_manager.sh" delete "${files[@]}"
            ;;
        3)
            bash "$SCRIPTS_DIR/file_manager.sh" list
            ;;
        4)
            read -p "Enter old filename: " oldname
            read -p "Enter new filename: " newname
            bash "$SCRIPTS_DIR/file_manager.sh" rename "$oldname" "$newname"
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

# Backup
run_backup() {
    echo "====== Backup ======"
    echo "Tip: you can drag-and-drop the folder or type absolute path"
    read -e -p "Enter directory to backup: " dir
    dir="$(realpath "$dir" 2>/dev/null || echo "$dir")"

    if [[ ! -d "$dir" ]]; then
        echo "Error: Directory does not exist"
        log "backup failed - invalid directory: $dir"
        return
    fi

    bash "$SCRIPTS_DIR/backup.sh" "$dir"
    if [[ $? -eq 0 ]]; then
        log "backup.sh executed successfully for $dir"
    else
        echo "backup.sh failed"
        log "backup.sh failed for $dir"
    fi
}

# Process Monitor
run_process_monitor() {
    echo "====== Process Monitor ======"
    bash "$SCRIPTS_DIR/process_monitor.sh" "$LOG_DIR"
}

# Run all
run_all() {
    echo "====== Running ALL scripts ======"
    log "Running all scripts"

    run_user_info
    run_system_check
    run_backup
    run_file_manager
    run_process_monitor

    echo "All scripts executed."
    log "All scripts executed"
}

# ----------------- MENU ----------------- #
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

# ----------------- MAIN LOOP ----------------- #
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
            log "User exited application"
            exit 0
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
done
