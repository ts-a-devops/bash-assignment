#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Ensure logs directory exists
mkdir -p logs

# Log file path
LOG_FILE="logs/app.log"

echo "==== DevOps Toolkit ===="

# Infinite loop for menu
while true; do
    echo ""
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"

    # Read user choice
    read -p "Choose an option: " choice

    case $choice in
        1)
            # Run multiple scripts
            echo "Running all scripts..." | tee -a "$LOG_FILE"
            ./scripts/user_info.sh
            ./scripts/system_check.sh
            ;;

        2)
            # Run only system check
            ./scripts/system_check.sh
            ;;

        3)
            # Ask for directory before backup
            read -p "Enter directory to backup: " dir
            ./scripts/backup.sh "$dir"
            ;;

        4)
            # Exit program
            echo "Exiting..."
            exit 0
            ;;

        *)
            # Handle invalid input
            echo "Invalid option"
            ;;
    esac
done
