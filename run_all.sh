#!/bin/bash
set -euo pipefail

LOG_FILE="logs/app.log"
mkdir -p logs

log_action() {
    echo "$1" >> "$LOG_FILE"
}

run_system_check() {
    echo "Running System Check..."
    ./scripts/system_check.sh
    log_action "Executed System Check"
}

run_backup() {
    read -p "Enter directory to backup: " BDIR
    if [ -d "$BDIR" ]; then
        ./scripts/backup.sh "$BDIR"
        log_action "Executed Backup for $BDIR"
    else
        echo "Error: Directory does not exist."
        log_action "Failed Backup Attempt: $BDIR not found"
    fi
}

run_all() {
	echo "Running All Scripts..."
	echo -e "\n--- [Step 1: User Validation] ---"
	./scripts/user_info.sh
	echo "Done. Pausing for 2 seconds..."
	sleep 2  # Automatic pause	
	./scripts/system_check.sh
	echo "Done. Pausing for 2 seconds..."
    	sleep 2  # Automatic pause
	./scripts/process_monitor.sh
	echo "Done. Pausing for 2 seconds..."
    	sleep 2  # Automatic pause
	log_action "Executed All Scripts"
}

# Interactive Menu
while true; do
    echo -e "\n--- DEVOPS TOOLKIT MENU ---"
    echo "1. Run All Scripts"
    echo "2. System Check"
    echo "3. Backup"
    echo "4. Exit"
    read -p "Select an option [1-4]: " CHOICE

    case "$CHOICE" in
        1) run_all ;;
        2) run_system_check ;;
        3) run_backup ;;
        4) 
            echo "Exiting..."
            log_action "User exited toolkit"
            exit 0 
            ;;
        *) 
            echo "Invalid option. Please try again." 
            ;;
    esac
done
