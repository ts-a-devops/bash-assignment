#!/bin/bash

set -euo pipefail

LOG_FILE="logs/app.log"

run_all() {
	echo "Running all scripts..." | tee -a "$LOG_FILE"
	./scripts/system_check.sh
	./scripts/user_info.sh
}

run_backup() {
	read -rp "Enter directory to backup: " dir
	./scripts/backup.sh "$dir"
}

menu() {
	while true; do
		echo "1. Run All"
		echo "2. System Check"
		echo "3. Backup"
		echo "4. Exit"
		
		read -rp "Choose option: " choice
		case $choice in
			1) run_all ;;
			2) ./scripts/system_check.sh ;;
			3) run_backup ;;
			4) exit 0 ;;
			*) echo "Invalid option" ;;
		esac
	done
}

menu
