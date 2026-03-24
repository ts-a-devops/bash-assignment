#!/bin/bash
set -euo pipefail

mkdir -p logs

LOG_FILE="logs/app.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_script() {
    local script=$1
    local description=$2
    
    log "Starting: $description"
    if bash "${SCRIPT_DIR}/${script}"; then
        log "SUCCESS: $description completed"
        return 0
    else
        log "FAILED: $description exited with error"
        return 1
    fi
}

show_menu() {
    clear
    echo "================================"
    echo "    DevOps Scripts Manager"
    echo "================================"
    echo "1. Run all scripts"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "================================"
    echo -n "Select option: "
}

run_all() {
    log "=== RUNNING ALL SCRIPTS ==="
    
    run_script "system_check.sh" "System Check" || true
    echo ""
    read -p "Press Enter to continue to User Info..."
    
    run_script "user_info.sh" "User Info" || true
    echo ""
    read -p "Press Enter to continue to File Manager..."
    
    run_script "file_manager.sh list" "File Manager" || true
    echo ""
    read -p "Press Enter to continue to Backup..."
    
    read -p "Enter directory to backup: " backup_dir
    run_script "backup.sh \"$backup_dir\"" "Backup" || true
    
    log "=== ALL SCRIPTS COMPLETE ==="
}

# Main loop
while true; do
    show_menu
    read -r choice
    
    case "$choice" in
        1)
            run_all
            read -p "Press Enter to continue..."
            ;;
        2)
            run_script "system_check.sh" "System Check"
            read -p "Press Enter to continue..."
            ;;
        3)
            read -p "Enter directory to backup: " backup_dir
            run_script "backup.sh" "Backup" <<< "$backup_dir"
            read -p "Press Enter to continue..."
            ;;
        4)
            log "Application exited by user"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option"
            sleep 1
            ;;
    esac
done
