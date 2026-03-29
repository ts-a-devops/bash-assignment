#!/bin/bash

set -euo pipefail

mkdir -p logs

LOG_FILE="logs/app.log"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

log_action() {
	echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

run_all() {
	echo "Running all scripts..."
	log_action "RUN ALL started"
	 ./scripts/system_check.sh || { log_action "system_check FAILED"; echo "System check failed"; }
	 ./scripts/backup.sh myfolder || { log_action "backup FAILED"; echo "Backup failed"; }
	 log_action "RUN ALL completed"
 }

 run_system_check() {
	 echo "Running system check..."
	  log_action "SYSTEM CHECK started"
	   ./scripts/system_check.sh || { log_action "system_check FAILED"; echo "System check failed"; }
	    log_action "SYSTEM CHECK completed"
    }

    run_backup() {
	    echo "Running backup..."
	     log_action "BACKUP started"
	     read -p "Enter directory to back up: " dir

	     ./scripts/backup.sh "$dir" || { log_action "backup FAILED"; echo "Backup failed"; }
	      log_action "BACKUP completed"
      }

      while true; do
    echo ""
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "================"
    read -p "Choose an option: " choice
    
 case $choice in
    1)
    run_all
;;
    2)
    run_system_check
;;

    3)
     run_backup
;;

    4)
    echo "Exiting..."
    log_action "Application exited"
    exit 0
;;

     *)
     echo "Invalid option"
     ;;
esac
done
