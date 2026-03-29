#!/bin/bash

set -euo pipefail

LOG_FILE="logs/app.log"
mkdir -p logs

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Functions
run_all() {
    log "Running all scripts..."

    run_script "system_check.sh"
    run_script "backup.sh ./test_dir"   # change path if needed
}

system_check() {
    log "Running system check..."
    run_script "system_check.sh"
}

backup() {
    read -p "Enter directory to back up: " dir
    run_script "backup.sh $dir"
}

# Helper to run scripts safely
run_script() {
    script_cmd=$1

    if bash scripts/$script_cmd; then
        log "$script_cmd executed successfully"
    else
        log "ERROR: $script_cmd failed"
    fi
}

# Menu
while true; do
    echo ""
    echo "===== MENU ====="
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    echo "================"

    read -p "Choose an option: " choice

    case $choice in
        1) run_all ;;
        2) system_check ;;
        3) backup ;;
        4) log "Exiting..."; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
