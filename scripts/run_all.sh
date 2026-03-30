#!/bin/bash

# 1. Setup - Use a variable for the script folder to keep things tidy
SCRIPT_DIR="./scripts"
LOG_FILE="../logs/app.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# 2. Define the "Run All" logic in one place
run_everything() {
    echo "--- Starting Full System Suite ---"
    bash "$SCRIPT_DIR/file_manager.sh" list
    bash "$SCRIPT_DIR/system_check.sh"
    bash "$SCRIPT_DIR/backup.sh" .
    bash "$SCRIPT_DIR/process_monitor.sh"
    bash "$SCRIPT_DIR/user_info.sh"
    echo "--- Suite Complete ---"
}

# 3. The Menu Logic
echo "Welcome to the App Manager"
echo "--------------------------"

# 'select' automatically creates a numbered menu and loops until you 'break' or 'exit'
PS3="Choose an option (1-4): " # This sets the prompt text for the select menu

select opt in "Run All" "System Check" "Backup" "Exit"; do
    case $opt in
        "Run All")
            run_everything | tee -a "$LOG_FILE"
            ;;
        "System Check")
            bash "$SCRIPT_DIR/system_check.sh" | tee -a "$LOG_FILE"
            ;;
        "Backup")
            bash "$SCRIPT_DIR/backup.sh" . | tee -a "$LOG_FILE"
            ;;
        "Exit")
            echo "Goodbye!"
            break # Exits the 'select' loop
            ;;
        *) 
            echo "Invalid choice. Please pick a number from the list."
            ;;
    esac
done