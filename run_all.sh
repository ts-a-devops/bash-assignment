#!/bin/bash
set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"
SCRIPTS_DIR="scripts"

mkdir -p "$LOG_DIR"

# Logger
log_message() {
	    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    }

# Graceful error handler
handle_error() {
    echo "⚠️  An error occurred. Check logs."
    log_message "ERROR at line $1"
}

trap 'handle_error $LINENO' ERR

# ---------------- FUNCTIONS ---------------- #

run_system_check() {
    echo "🔍 Running system check..."
    log_message "START: system_check"

if bash "$SCRIPTS_DIR/system_check.sh"; then
    log_message "SUCCESS: system_check"
else
    log_message "FAILED: system_check"
fi
}

run_backup() {
read -p "Enter directory to back up: " DIR

if [[ -z "$DIR" ]]; then
    echo "Directory cannot be empty."
    log_message "FAILED: backup (empty input)"
return
fi

    log_message "START: backup ($DIR)"

if bash "$SCRIPTS_DIR/backup.sh" "$DIR"; then
    log_message "SUCCESS: backup ($DIR)"					
else
    log_message "FAILED: backup ($DIR)"						
fi
}

run_file_manager() {
    echo "📁 File Manager"
    echo "1. Create"
    echo "2. Delete"
    echo "3. List"
    echo "4. Rename"

read -p "Choose option [1-4]: " choice

case $choice in
	1)
	    read -p "Enter filename: " file
	    bash "$SCRIPTS_DIR/file_manager.sh" create "$file"
	    ;;
	2)
	    read -p "Enter filename: " file
	    bash "$SCRIPTS_DIR/file_manager.sh" delete "$file"
	    ;;
	3)
	    bash "$SCRIPTS_DIR/file_manager.sh" list
	    ;;
	4)
	    read -p "Old name: " old
	    read -p "New name: " new
	    bash "$SCRIPTS_DIR/file_manager.sh" rename "$old" "$new"
	    ;;

	*)
	    echo "Invalid option"
	    ;;
esac

log_message "EXECUTED: file_manager"
}

run_process_monitor() {
    read -p "Enter process name: " process
if [[ -z "$process" ]]; then
    echo "Process name cannot be empty."
    log_message "FAILED: process_monitor (emputy input)"
    return
fi

log_message "START: process_monitor ($process)"

if bash "$SCRIPTS_DIR/process_monitor.sh" "$process"; then
    log_message "SUCCESS: process_monitor ($process)"
else
    log_message "FAILED: process_monitor ($process)"
fi
}

run_all() {
    echo "🚀 Running all tasks..."
    log_message "START: run_all"

    run_system_check
    run_backup
    run_process_monitor

    log_message "COMPLETED: run_all"
}

# ---------------- MENU ---------------- #

show_menu() {
    echo ""
    echo "========== DevOps Toolkit =========="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. File manager"
    echo "5. Process monitor"
    echo "6. Exit"
    echo "===================================="
}

# ---------------- MAIN LOOP ---------------- #

while true; do
    show_menu
    read -p "Select option [1-6]: " choice

case $choice in
    1) run_all ;;
    2) run_system_check ;;
    3) run_backup ;;
    4) run_file_manager ;;
    5) run_process_monitor ;;
    6)
	    
        echo "👋 Exiting..."
	log_message "EXIT: User exited"
	exit 0
	;;
    *)
        echo "Invalid option. Try again."
	;;
esac
done
