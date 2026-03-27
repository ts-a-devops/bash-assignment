#!/b#!/bin/bash

set -euo pipefail

LOG_FILE="logs/run_all.log"
SCRIPTS_DIR="scripts"

mkdir -p logs

# Log everything
exec > >(tee -a "$LOG_FILE") 2>&1

# ---------- FUNCTIONS ----------

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

run_system_check() {
    echo "$(timestamp) INFO: Running system check..."
    bash "$SCRIPTS_DIR/system_check.sh"
}

run_backup() {
    read -p "Enter directory to backup: " dir

    if [[ ! -d "$dir" ]]; then
        echo "$(timestamp) ERROR: Directory does not exist"
        return
    fi

    echo "$(timestamp) INFO: Running backup..."
    bash "$SCRIPTS_DIR/backup.sh" "$dir"
}

run_all() {
    echo "$(timestamp) INFO: Running all tasks..."
    run_system_check
    run_backup
}

show_menu() {
    echo "========================="
    echo "  SYSTEM CONTROL MENU"
    echo "========================="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
}

# ---------- MAIN LOOP ----------

while true; do
    show_menu
    read -p "Choose an option: " choice

    case "$choice" in
        1)
            run_all
            ;;
        2)
            run_system_check
            ;;
        3)
            run_backup
            ;;
        4)
            echo "$(timestamp) INFO: Exiting..."
            exit 0
            ;;
        *)
            echo "$(timestamp) ERROR: Invalid option"
            ;;
    esac
donein/bash

set -euo pipefail

LOG_FILE="logs/run_all.log"
SCRIPTS_DIR="scripts"

mkdir -p logs

# Log everything
exec > >(tee -a "$LOG_FILE") 2>&1

# ---------- FUNCTIONS ----------

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

run_system_check() {
    echo "$(timestamp) INFO: Running system check..."
    bash "$SCRIPTS_DIR/system_check.sh"
}

run_backup() {
    read -p "Enter directory to backup: " dir

    if [[ ! -d "$dir" ]]; then
        echo "$(timestamp) ERROR: Directory does not exist"
        return
    fi

    echo "$(timestamp) INFO: Running backup..."
    bash "$SCRIPTS_DIR/backup.sh" "$dir"
}

run_all() {
    echo "$(timestamp) INFO: Running all tasks..."
    run_system_check
    run_backup
}

show_menu() {
    echo "========================="
    echo "  SYSTEM CONTROL MENU"
    echo "========================="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
}

# ---------- MAIN LOOP ----------

while true; do
    show_menu
    read -p "Choose an option: " choice

    case "$choice" in
        1)
            run_all
            ;;
        2)
            run_system_check
            ;;
        3)
            run_backup
            ;;
        4)
            echo "$(timestamp) INFO: Exiting..."
            exit 0
            ;;
        *)
            echo "$(timestamp) ERROR: Invalid option"
            ;;
    esac
done
