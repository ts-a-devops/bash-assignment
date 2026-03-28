#!/bin/bash

set -euo pipefail

mkdir -p logs
log_file="logs/app.log"

run_script() {
    local script=$1
    echo "Running $script..."
    bash "$script" 2>&1 | tee -a "$log_file"
    echo "$(date): $script completed" >> "$log_file"
}

show_menu() {
    echo ""
    echo "=== DevOps Bash Toolkit ==="
    echo "1. Run all scripts"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "Enter choice:"
    read choice

    case $choice in
        1)
            run_script "scripts/system_check.sh"
            run_script "scripts/process_monitor.sh"
            bash scripts/backup.sh scripts
            ;;
        2)
            run_script "scripts/system_check.sh"
            ;;
        3)
            echo "Enter directory to backup:"
            read dir
            bash scripts/backup.sh "$dir"
            ;;
        4)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

while true; do
    show_menu
done
