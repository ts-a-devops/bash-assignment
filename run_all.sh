#!/bin/bash
# run_all.sh - Interactive menu to run toolkit scripts

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/app.log"
mkdir -p "$LOG_DIR"

log_app() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

run_script() {
    local script=$1
    echo "Running $script..."
    log_app "Starting $script"
    if "./scripts/$script"; then
        log_app "$script completed successfully"
    else
        log_app "ERROR: $script failed"
        echo "Warning: $script encountered an error (continuing...)"
    fi
}

while true; do
    echo
    echo "=== DevOps Bash Toolkit Menu ==="
    echo "1. Run All Scripts"
    echo "2. System Check Only"
    echo "3. Perform Backup (provide directory)"
    echo "4. Exit"
    read -rp "Choose an option (1-4): " choice

    case $choice in
        1)
            echo "Running all scripts..."
            run_script "user_info.sh"
            run_script "system_check.sh"
            run_script "file_manager.sh"  # list as example
            # For backup and process, interactive or skip heavy ones
            echo "Skipping interactive backup/process for 'Run All'"
            log_app "Completed Run All (partial)"
            ;;
        2)
            run_script "system_check.sh"
            ;;
        3)
            read -rp "Enter directory to backup: " backup_dir
            if [[ -d "$backup_dir" ]]; then
                ./scripts/backup.sh "$backup_dir"
            else
                echo "Invalid directory."
            fi
            ;;
        4)
            echo "Exiting..."
            log_app "Session ended"
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
