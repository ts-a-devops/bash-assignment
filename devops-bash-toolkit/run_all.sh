#!/bin/bash
set -euo pipefail

LOG_FILE="logs/app.log"
mkdir -p logs

function run_all() {
    bash scripts/system_check.sh
    echo "Enter directory to backup:"
    read dir
    bash scripts/backup.sh "$dir"
}

function system_check() {
    bash scripts/system_check.sh
}

function backup() {
    read -p "Enter directory: " dir
    bash scripts/backup.sh "$dir"
}

while true; do
    echo "1) Run All"
    echo "2) System Check"
    echo "3) Backup"
    echo "4) Exit"
    read -p "Choose option: " choice

    case $choice in
        1) run_all | tee -a "$LOG_FILE" ;;
        2) system_check | tee -a "$LOG_FILE" ;;
        3) backup | tee -a "$LOG_FILE" ;;
        4) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
