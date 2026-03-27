#!/bin/bash

set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

LOG_FILE="logs/app.log"

log_action() {
    echo "[$(date)] $1" >> $LOG_FILE
}

run_all() {
    echo "Running all checks..."

    log_action "Running system check"
    ./scripts/system_check.sh

    log_action "Running backup"
    ./scripts/backup.sh scripts

    log_action "Running process monitor for ssh"
    ./scripts/process_monitor.sh ssh
}

system_check() {
    log_action "User selected system check"
    ./scripts/system_check.sh
}

backup() {
    log_action "User selected backup"
    ./scripts/backup.sh scripts
}

while true
do
    echo ""
    echo "DevOps Bash Toolkit Menu"
    echo "1) Run All"
    echo "2) System Check"
    echo "3) Backup"
    echo "4) Exit"

    read -p "Choose an option: " choice

    case $choice in
        1)
            run_all
            ;;
        2)
            system_check
            ;;
        3)
            backup
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
