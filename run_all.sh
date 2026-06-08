#!/bin/bash
# run_all.sh - interactive menu for the DevOps Bask Toolkit
# Written by Dave Woks

set -euo pipefail 

mkdir -p ~/bash-assignment/logs
LOGFILE=~/bash-assignment/logs/app.log

log_action() {
    echo "[$(date +%F\ %T)] $1" >> "$LOGFILE"
}

run_script() {
    local SCRIPT=$1
    if [[ -f "$SCRIPT" ]]; then
        bash "$SCRIPT"
        log_action "Ran: $SCRIPT"
    else
        echo "Error: $SCRIPT not found."
        log_action "ERROR: $SCRIPT not found."
    fi
}

echo "======================================"
echo "    Dave Woks DevOps Bash Toolkit     "
echo "======================================"

select OPTION in "Run All Scripts" "System Check" "Backup Scripts Folder" "Exit"; do
    case $OPTION in
        "Run All Scripts")
		echo ""
		echo " --- Running all scripts ---"
		run_script scripts/user_info.sh
		run_script scripts/system_check.sh
		run_script scripts/process_monitor.sh
		log_action "All scripts executed."
		;;
        "System Check")
		echo ""
		run_script scripts/system_check.sh
		;;
        "Backup Scripts Folder")
		echo ""
		bash scripts/backup.sh scripts
		log_action "Backup triggered from menu"
		;;
      "Exit")
		echo "Goodbye!"
		log_action "Toolkit exited."
		break
		;;
        *)
		echo "Invalid option."
		;;
     esac
done
