#!/bin/bash

# Strict error handling
set -euo pipefail

LOG_FILE="logs/app.log"

# Function to run System Check
run_system_check() {
    echo "[$(date)] Starting System Check..." | tee -a "$LOG_FILE"
    ./scripts/system_check.sh || echo "Error: System check failed." | tee -a "$LOG_FILE"
     }

# Function to run Backup 
        run_backup() {
	       	echo "[$(date)] Starting Backup..." | tee -a "$LOG_FILE"
                ./scripts/backup.sh ./scripts || echo "Error: Backup failed." | tee -a "$LOG_FILE"
                }

# Interactive Menu
                while true; do
			echo -e "\n--- Master Toolkit Menu ---"
                        echo "1. Run all"
			echo "2. System check"
			echo "3. Backup"
			echo "4. Exit"
			read -p "Select an option: " choice

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
				  echo "Exiting. Goodbye!"
				  exit 0
				  ;;
			  *)
				  echo "Invalid option, try again."
				  ;;
		  esac
	  done
