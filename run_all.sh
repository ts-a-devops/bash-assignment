#!/bin/bash

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

run_script() {
    local script_path=$1
    local script_name=$(basename "$script_path")
    
    log_action "Starting: $script_name"
    if bash "$script_path"; then
        log_action "Completed: $script_name"
        return 0
    else
        log_action "FAILED: $script_name"
        echo "Warning: $script_name failed, continuing..."
        return 1
    fi
}

show_menu() {
    echo ""
    echo "=== DevOps Bash Toolkit ==="
    echo "1. Run all scripts"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo ""
}

while true; do
    show_menu
    read -p "Select an option [1-4]: " choice
    
    case $choice in
        1)
            log_action "=== Running All Scripts ==="
            run_script "scripts/user_info.sh"
            echo "---"
            run_script "scripts/system_check.sh"
            echo "---"
            mkdir -p test_data && echo "test content" > test_data/test.txt
            run_script "scripts/backup.sh test_data"
            echo "---"
            run_script "scripts/file_manager.sh list ."
            echo "---"
            run_script "scripts/process_monitor.sh"
            log_action "=== All Scripts Completed ==="
            ;;
        2)
            run_script "scripts/system_check.sh"
            ;;
        3)
            mkdir -p test_data && echo "test content" > test_data/test.txt
            run_script "scripts/backup.sh test_data"
            ;;
        4)
            log_action "Application exited by user"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please select 1-4."
            ;;
    esac
    echo ""
    read -p "Press Enter to continue..."
done
