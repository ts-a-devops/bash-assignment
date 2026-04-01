#!/bin/bash
# Use absolute paths based on the script location
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

set -euo pipefail

# Ensure the logs directory exists
mkdir -p "$PROJECT_ROOT/logs"
LOG="$PROJECT_ROOT/logs/app.log"

log_exec() {
    echo "Executing $1..." | tee -a "$LOG"
    # Call the script using its absolute path
    "$SCRIPT_DIR/$1" || echo "Error in $1" >> "$LOG"
}

while true; do
    echo "--- MAIN MENU ---"
    echo "1. User Info  2. System Check  3. Backup  4. Monitor  5. Exit"
    read -p "Choice: " choice
    case $choice in
        1) log_exec "user_info.sh" ;;
        2) log_exec "system_check.sh" ;;
        3) read -p "Dir to backup: " d; "$SCRIPT_DIR/backup.sh" "$d" ;;
        4) log_exec "process_monitor.sh" ;;
        5) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
