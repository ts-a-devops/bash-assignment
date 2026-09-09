#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$BASE_DIR/scripts"
LOGS_DIR="$BASE_DIR/logs"
LOG_FILE="$LOGS_DIR/app.log"

mkdir -p "$LOGS_DIR"

log_app() {
    local msg="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [run_all] - $msg" >> "$LOG_FILE"
}

run_system_check() {
    log_app "Triggered: System Check"
    echo -e "\n>>> Executing System Check..."
    bash "$SCRIPTS_DIR/system_check.sh"
}

run_backup() {
    log_app "Triggered: Backup"
    echo -e "\n>>> Executing Backup on 'scripts' directory..."
    bash "$SCRIPTS_DIR/backup.sh" "$SCRIPTS_DIR"
}

run_all_tasks() {
    log_app "Triggered: Run All Tasks"
    echo -e "\n=========================================="
    echo "       RUNNING COMPLETE TOOLKIT SUITE      "
    echo "=========================================="
    
    echo -e "\n[1/4] Running User Info..."
    bash "$SCRIPTS_DIR/user_info.sh"
    
    echo -e "\n[2/4] Running System Check..."
    bash "$SCRIPTS_DIR/system_check.sh"
    
    echo -e "\n[3/4] Running File Manager Test..."
    bash "$SCRIPTS_DIR/file_manager.sh" list
    
    echo -e "\n[4/4] Running Backup on 'scripts'..."
    bash "$SCRIPTS_DIR/backup.sh" "$SCRIPTS_DIR"
    
    echo -e "\n[Bonus] Running Process Monitor..."
    bash "$SCRIPTS_DIR/process_monitor.sh"
    
    echo -e "\n>>> All tasks completed successfully."
    log_app "Completed: Run All Tasks"
}

display_menu() {
    while true; do
        echo -e "\n=========================================="
        echo "       DEVOPS TOOLKIT MAIN MENU           "
        echo "=========================================="
        echo "1. Run all"
        echo "2. System check"
        echo "3. Backup"
        echo "4. Exit"
        echo "------------------------------------------"
        read -p "Select an option [1-4]: " choice

        case "$choice" in
            1)
                run_all_tasks
                ;;
            2)
                run_system_check
                ;;
            3)
                run_backup
                ;;
            4)
                echo "Exiting toolkit. Goodbye!"
                log_app "Application exited by user."
                exit 0
                ;;
            *)
                echo "Invalid selection. Please choose an option between 1 and 4."
                ;;
        esac
    done
}

log_app "Application started."
display_menu
