#!/bin/bash

set -euo pipefail

mkdir -p logs
LOG_FILE="logs/app.log"

services=("nginx" "ssh" "docker")

run_all() {
    echo "Running all scripts..." | tee -a "$LOG_FILE"

    ./scripts/user_info.sh
    ./scripts/system_check.sh
    ./scripts/backup.sh .

    echo "Checking services..." | tee -a "$LOG_FILE"
    for service in "${services[@]}"; do
        ./scripts/process_monitor.sh "$service"
    done
}

system_check() {
    ./scripts/system_check.sh
}

backup() {
    read -p "Enter directory to backup: " dir
    ./scripts/backup.sh "$dir"
}

while true; do
    echo "========================"
    echo "1. Run All"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    echo "========================"

    read -p "Choose option: " choice

    case $choice in
        1) run_all | tee -a "$LOG_FILE" ;;
        2) system_check | tee -a "$LOG_FILE" ;;
        3) backup | tee -a "$LOG_FILE" ;;
        4) echo "Exiting..." ; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done