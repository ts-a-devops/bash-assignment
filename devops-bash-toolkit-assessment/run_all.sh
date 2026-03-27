#!/bin/bash

# 1. Strict Mode
set -euo pipefail

# 2. Setup Environment
SCRIPT_DIR="scripts"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"

[ ! -d "$LOG_DIR" ] && mkdir "$LOG_DIR"

log_action() {
    local MSG="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $MSG" >> "$LOG_FILE"
}

# 3. Logic Functions for each script
run_system_check() {
    echo -e "\n--- Starting System Check ---"
    log_action "Started: system_check.sh"
    bash "$SCRIPT_DIR/system_check.sh" || log_action "FAILED: system_check.sh"
}

run_backup() {
    echo -e "\n--- Starting Backup ---"
    read -p "Enter directory to backup: " DIR
    log_action "Started: backup.sh on $DIR"
    bash "$SCRIPT_DIR/backup.sh" "$DIR" || log_action "FAILED: backup.sh"
}

run_user_info() {
    echo -e "\n--- Starting User Info Collection ---"
    log_action "Started: user_info.sh"
    bash "$SCRIPT_DIR/user_info.sh" || log_action "FAILED: user_info.sh"
}

run_process_monitor() {
    echo -e "\n--- Starting Process Monitor ---"
    log_action "Started: process_monitor.sh"
    bash "$SCRIPT_DIR/process_monitor.sh" || log_action "FAILED: process_monitor.sh"
}

run_file_manager() {
    echo -e "\n--- File Manager ---"
    echo "1) Create  2) Delete  3) List  4) Rename"
    read -p "Select action: " FM_ACTION
    read -p "Target file/name: " FM_TARGET
    
    case $FM_ACTION in
        1) bash "$SCRIPT_DIR/file_manager.sh" create "$FM_TARGET" ;;
        2) bash "$SCRIPT_DIR/file_manager.sh" delete "$FM_TARGET" ;;
        3) bash "$SCRIPT_DIR/file_manager.sh" list ;;
        4) read -p "New name: " FM_NEW; bash "$SCRIPT_DIR/file_manager.sh" rename "$FM_TARGET" "$FM_NEW" ;;
    esac
}

# 4. Interactive Menu
show_menu() {
    while true; do
        echo -e "\n======================================"
        echo "   ROGERS' DEVOPS AUTOMATION SUITE"
        echo "======================================"
        echo "1) System Health Check"
        echo "2) Directory Backup"
        echo "3) User Information Portal"
        echo "4) Process & Service Monitor"
        echo "5) File Manager Operations"
        echo "6) Run All Critical (Check + Monitor + Backup)"
        echo "7) Exit"
        echo "--------------------------------------"
        read -p "Selection [1-7]: " CHOICE

        case $CHOICE in
            1) run_system_check ;;
            2) run_backup ;;
            3) run_user_info ;;
            4) run_process_monitor ;;
            5) run_file_manager ;;
            6) run_system_check; run_process_monitor; run_backup ;;
            7) log_action "Session Ended."; exit 0 ;;
            *) echo "Invalid choice." ;;
        esac
    done
}

show_menu
