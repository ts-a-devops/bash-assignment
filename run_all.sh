#!/bin/bash

# DevOps Bash Toolkit - Main Menu
# Interactive menu to run all tools

set -euo pipefail

log_file="logs/app.log"
mkdir -p logs

echo "========================================"
echo "   DevOps Bash Toolkit - Main Menu"
echo "========================================"
echo "1. Run all"
echo "2. System check"
echo "3. User info"
echo "4. Backup"
echo "5. Exit"
echo ""

read -p "Select an option (1-5): " choice

if [ "$choice" = "1" ]; then
    echo "Running all scripts..."
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Running all scripts" >> "$log_file"
    
    echo "===== User Info ====="
    ./scripts/user_info.sh
    
    echo "===== System Check ====="
    ./scripts/system_check.sh
    
    echo "All scripts completed"
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] All scripts completed" >> "$log_file"

elif [ "$choice" = "2" ]; then
    echo "Running system check..."
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Running system_check.sh" >> "$log_file"
    ./scripts/system_check.sh

elif [ "$choice" = "3" ]; then
    echo "Running user info..."
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Running user_info.sh" >> "$log_file"
    ./scripts/user_info.sh

elif [ "$choice" = "4" ]; then
    echo "Running backup..."
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Running backup.sh" >> "$log_file"
    read -p "Enter directory to backup: " backup_dir
    ./scripts/backup.sh "$backup_dir"

elif [ "$choice" = "5" ]; then
    echo "Goodbye!"
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Exited application" >> "$log_file"

else
    echo "Invalid option"
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Invalid option: $choice" >> "$log_file"
fi
