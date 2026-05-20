#!/bin/bash

set -euo pipefail

run_script() {
    local script=$1
    if [ -f "scripts/$script" ]; then
        bash "scripts/$script"
    else
        echo "Error: scripts/$script not found."
    fi
}

while true; do
    echo ""
    echo "=== DEVOPS TOOLKIT MENU ==="
    echo "1. Run all scripts"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo ""
    read -p "Choose an option (1-4): " choice

    case $choice in
        1)
            bash scripts/user_info.sh
            bash scripts/system_check.sh
            bash scripts/backup.sh
            bash scripts/process_monitor.sh
            ;;
        2) run_script "system_check.sh" ;;
        3) run_script "backup.sh" ;;
        4) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Please choose 1-4." ;;
    esac
done
