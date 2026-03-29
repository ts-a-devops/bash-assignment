#!/bin/bash
# run_all.sh - interactive menu to run all DevOps scripts

set -euo pipefail

LOGFILE="logs/app.log"
mkdir -p logs

# Function to log actions
log_action() {
    echo "$(date '+%F %T') - $1" >> $LOGFILE
}

# Functions to call scripts
run_user_info() {
    ./scripts/user_info.sh
    log_action "Ran user_info.sh"
}

run_system_check() {
    ./scripts/system_check.sh
    log_action "Ran system_check.sh"
}

run_file_manager() {
    echo "Example: ./scripts/file_manager.sh create testfile.txt"
    ./scripts/file_manager.sh "$@"
    log_action "Ran file_manager.sh with args: $*"
}

run_backup() {
    ./scripts/backup.sh "$@"
    log_action "Ran backup.sh with args: $*"
}

run_process_monitor() {
    ./scripts/process_monitor.sh "$@"
    log_action "Ran process_monitor.sh with args: $*"
}

# Interactive menu
while true; do
    echo "============================="
    echo " DevOps Bash Toolkit Menu"
    echo "============================="
    echo "1) Run all scripts"
    echo "2) System check"
    echo "3) Backup"
    echo "4) Exit"
    echo -n "Choose an option: "
    read choice

    case $choice in
        1)
            echo "Running user info..."
            run_user_info
            echo "Running system check..."
            run_system_check
            echo "Running file manager (example create)..."
            run_file_manager create sample.txt
            echo "Running backup (example scripts/)..."
            run_backup scripts
            echo "Running process monitor..."
            run_process_monitor
            ;;
        2)
            run_system_check
            ;;
        3)
            echo -n "Enter directory to backup: "
            read dir
            run_backup "$dir"
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
