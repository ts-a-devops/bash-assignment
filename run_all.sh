#!/bin/bash
# --------------------------------------------------------------------------
# Script: run_all.sh
# Description: Interactive menu to run various toolkit scripts.
#              Uses set -euo pipefail for strict error handling.
# --------------------------------------------------------------------------

# Set strict bash mode:
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error.
# -o pipefail: Pipeline failure counts if any command in pipeline fails.
set -euo pipefail

LOG_DIR="logs"
mkdir -p "$LOG_DIR"
GLOBAL_LOG="$LOG_DIR/app.log"

log_global() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$GLOBAL_LOG"
}

log_global "[INFO] run_all.sh session started."

# Functions to wrap script executions
run_system_check() {
    echo ">> Running System Check..."
    log_global "[ACTION] Executing system_check.sh"
    # Execute the script (We use bash to ensure it runs even if +x is missing, 
    # though we'll chmod +x them anyway!)
    bash scripts/system_check.sh
}

run_backup() {
    echo ">> Running Backup... (Defaulting 'scripts/' directory for demo)"
    log_global "[ACTION] Executing backup.sh on 'scripts/' dir"
    bash scripts/backup.sh scripts/
}

# The while true loop continues indefinitely until we hit 'exit' (break)
while true; do
    echo "=========================================="
    echo "      DevOps Bash Toolkit Menu            "
    echo "=========================================="
    echo "1. Run all (System Check + Backup)"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    echo "=========================================="
    
    # Collect the user's choice
    # We briefly turn off '-e' so an empty/bad read doesn't crash the script immediately
    set +e
    read -p "Choose an option [1-4]: " choice
    set -e
    
    case "$choice" in
        1)
            run_system_check
            echo ""
            run_backup
            echo ">> Run all completed."
            ;;
        2)
            run_system_check
            ;;
        3)
            run_backup
            ;;
        4)
            echo "Exiting the toolkit. Goodbye!"
            log_global "[INFO] run_all.sh session closed."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            log_global "[WARNING] User inputted invalid menu option: '$choice'"
            ;;
    esac
    
    echo ""
done
