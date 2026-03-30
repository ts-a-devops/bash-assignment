#!/bin/bash
# run_all.sh - Interactive menu to run toolkit scripts

set -euo pipefail
mkdir -p logs
LOG_FILE="logs/app.log"

function system_check() {
	./scripts/system_check.sh | tee -a "$LOG_FILE"
}
function backup() {
	read -p "Enter directory to backup: " dir
	./scripts/backup.sh "$dir" | tee -a "$LOG_FILE"
}

while true; do
	echo "1) Run all"
	echo "2) System check"
	echo "3) Backup"
	echo "4) Exit"
	read -p "Choose option: " choice
	case $choice in
		1) ./scripts/system_check.sh && ./scripts/backup.sh ./some_dir ;;
		2) system_check ;;
		3) backup ;;
		4) exit 0 ;;
		*) echo "Invalid option" ;;
	esac
done
