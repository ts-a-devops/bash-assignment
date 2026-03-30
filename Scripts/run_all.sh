#!/bin/bash
set -euo pipefail

# Configuration
SCRIPT_DIR="./scripts"
LOG_FILE="logs/app.log"
mkdir -p logs

# Function to log actions
log_msg() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to run individual scripts safely
run_script() {
    local script_name=$1
    local script_path="$SCRIPT_DIR/$script_name"

    if [[ -x "$script_path" ]]; then
        log_msg "Starting $script_name..."
        if "$script_path"; then
            log_msg "SUCCESS: $script_name completed."
        else
            log_msg "FAILURE: $script_name exited with an error."
        fi
    else
        log_msg "ERROR: $script_name not found or not executable in $SCRIPT_DIR."
    fi
}

# Interactive Menu
while true; do
    echo -e "\n--- Master Management Menu ---"
    echo "1. Run All Scripts"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    read -p "Select an option [1-4]: " choice

    case $choice in
        1)
            log_msg "User selected: Run All"
            run_script "user_info.sh"
            run_script "system_check.sh"
            run_script "backup.sh" "." # Backs up current dir by default
            run_script "process_monitor.sh"
            ;;
        2)
            log_msg "User selected: System Check"
            run_script "system_check.sh"
            ;;
        3)
            log_msg "User selected: Backup"
            read -p "Enter directory to backup: " target_dir
            run_script "backup.sh" "$target_dir"
            ;;
        4)
            log_msg "Exiting Master Menu."
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
