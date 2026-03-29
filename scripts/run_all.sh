#!/bin/bash
# Main menu script

set -euo pipefail   

mkdir -p logs

echo "===================================="
echo "   DevOps Bash Toolkit - Menu"
echo "===================================="

while true; do
    echo ""
    echo "1. Run All Scripts"
    echo "2. System Check Only"
    echo "3. Create Backup"
    echo "4. Exit"
    read -p "Enter your choice (1-4): " choice

    case $choice in
        1)
            echo "Running all scripts..."
            ./scripts/user_info.sh
            ./scripts/system_check.sh
            ./scripts/file_manager.sh list
            ./scripts/backup.sh .
            ;;
        2)
            ./scripts/system_check.sh
            ;;
        3)
            ./scripts/backup.sh .
            ;;
        4)
            echo "Thank you!"
            exit 0
            ;;
        *)
            echo "Please choose a number between 1 and 4."
            ;;
    esac
done