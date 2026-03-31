#!/bin/bash
set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/app.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

run_script() {
    local script=$1
    log "INFO: Running $script"
    if bash $script 2>&1; then
        log "INFO: $script completed successfully"
    else
        log "ERROR: $script failed — continuing"
    fi
}
echo "=============================="
echo "   DevOps Bash Toolkit"
echo "   Author: Toluwani"
echo "=============================="
echo ""
show_menu() {
    echo ""
    echo "===== DevOps Bash Toolkit ====="
    echo "1) Run All Scripts"
    echo "2) System Check"
    echo "3) Backup"
    echo "4) Exit"
    echo "==============================="
    read -rp "Choose an option: " choice
}

while true; do
    show_menu
    case $choice in
        1)
            log "INFO: Running all scripts"
          run_script "scripts/system_check.sh"
run_script "scripts/file_manager.sh list"
run_script "scripts/backup.sh ."
run_script "scripts/process_monitor.sh nginx"
            ;;
        2)
            run_script "./scripts/system_check.sh"
            ;;
        3)
            run_script "./scripts/backup.sh ./"
            ;;
        4)
            log "INFO: Exiting"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
done
