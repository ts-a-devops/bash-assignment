#!/bin/bash

# 1. Strict Mode
set -euo pipefail

# 2. Configuration
SCRIPT_DIR="scripts"
LOG_FILE="$SCRIPT_DIR/logs/app.log"

# Ensure the logs directory exists inside scripts/
mkdir -p "$SCRIPT_DIR/logs"

# 3. Logic: Function to handle logging
log_msg() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# 4. Logic: Function to organize script execution
run_script() {
    local script_name=$1
    local script_arg=${2:-""}
    local script_path="./$SCRIPT_DIR/$script_name"

    if [[ -x "$script_path" ]]; then
        log_msg "Starting: $script_name"
        
        # Move into scripts folder temporarily to keep results contained there
        if ( cd "$SCRIPT_DIR" && "./$script_name" "$script_arg" ); then
            log_msg "Completed: $script_name successfully."
        else
            log_msg "FAILED: $script_name returned an error code."
        fi
    else
        echo "Error: $script_path not found or not executable."
        log_msg "ERROR: Missing or non-executable script: $script_name"
    fi
}

# --- Interactive Menu ---

echo "========================================"
echo "    DEVOPS BASH TOOLKIT CONTROLLER"
echo "========================================"

PS3="Please select an option (1-4): "
options=("Run All" "System Check" "Backup" "Exit")

select opt in "${options[@]}"; do
    case $opt in
        "Run All")
            log_msg "User initiated: Run All"
            run_script "system_check.sh"
            run_script "backup.sh" "." # Backs up current scripts folder
            ;;
        "System Check")
            run_script "system_check.sh"
            ;;
        "Backup")
            read -p "Enter the directory name to backup: " dir_to_bk
            run_script "backup.sh" "$dir_to_bk"
            ;;
        "Exit")
            log_msg "User exited Menu."
            echo "Goodbye!"
            break
            ;;
        *) 
            echo "Invalid selection: $REPLY. Please choose 1-4."
            ;;
    esac
    echo -e "\n--- Menu Reloaded ---"
done

