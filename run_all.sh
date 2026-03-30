#!/bin/bash


set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/app.log"

log() {
	echo "$(date): $1" >> "$LOG_FILE"
}

run_system_check() {
	bash scripts/system_check.sh
	log "Ran system check"
}

run_backup() {
	read -p "Enter directory to back up: " dir
	bash scripts/backup.sh "$dir"
	log "Ran backup fot $dir"
}

while true; do
	echo "1. Run All"
	echo "2. System Check"
	echo "3. Backup"
	echo "4. Exit"

	read -p "Choose an option: " choice

	case $choice in
		1)
			run_system_check
			run_backup
			;;
		2)
			run_system_check
			;;
		3)
			run_backup
			;;
		4)
			echo "Exiting..."
			break
			;;
		*)
			echo "Invalid option"
			;;
	esac
done
