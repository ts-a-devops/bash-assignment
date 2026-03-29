#!/bin/bash

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"
SCRIPT_DIR="scripts"

mkdir -p "$LOG_DIR"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

run_user_info() {
    log_action "Running user_info script"

    if bash "$SCRIPT_DIR/user_info.sh"; then
        log_action "user_info completed"
    else
        log_action "user_info failed"
        echo "user_info failed"
    fi
}

run_system_check() {
    log_action "Running system_check script"

    if bash "$SCRIPT_DIR/system_check.sh"; then
        log_action "system_check completed"
    else
        log_action "system_check failed"
        echo "system_check failed"
    fi
}

run_file_manager() {
    log_action "Running file_manager script"

    read -p "Enter command (create/delete/list/rename): " cmd
    read -p "Enter filename: " file

    if bash "$SCRIPT_DIR/file_manager.sh" "$cmd" "$file"; then
        log_action "file_manager completed"
    else
        log_action "file_manager failed"
        echo "file_manager failed"
    fi
}

run_backup() {
    read -p "Enter directory to backup: " dir

    log_action "Running backup for $dir"

    if bash "$SCRIPT_DIR/backup.sh" "$dir"; then
        log_action "backup completed"
    else
        log_action "backup failed"
        echo "backup failed"
    fi
}

run_process_monitor() {
    read -p "Enter process name: " process

    log_action "Running process monitor for $process"

    if bash "$SCRIPT_DIR/process_monitor.sh" "$process"; then
        log_action "process_monitor completed"
    else
        log_action "process_monitor failed"
        echo "process_monitor failed"
    fi
}

run_all() {
    echo "Running all scripts..."

    log_action "Run all started"

    run_user_info
    run_system_check

    echo "File manager skipped (requires manual command)"
    echo "Process monitor skipped (requires process input)"

    log_action "Run all completed"
}

show_menu() {
    echo ""
    echo "====== Bash Assignment ======"
    echo "1. Run all"
    echo "2. User info"
    echo "3. System check"
    echo "4. File manager"
    echo "5. Backup"
    echo "6. Process monitor"
    echo "7. Exit"
    echo "============================="
}

while true; do

    show_menu

    read -p "Choose option: " choice

    case $choice in
        1)
            run_all
            ;;
        2)
            run_user_info
            ;;
        3)
            run_system_check
            ;;
        4)
            run_file_manager
            ;;
        5)
            run_backup
            ;;
        6)
            run_process_monitor
            ;;
        7)
            log_action "Application exited"
            echo "Goodbye"
            exit 0
            ;;
        *)
            echo "Invalid option"
            log_action "Invalid option selected"
            ;;
    esac

done
