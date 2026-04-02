#!/bin/bash
set -euo pipefail

LOG_FILE="../logs/app.log"

run_all() {
bash file_manager.sh list
bash system_check.sh
bash backup.sh .
bash process_monitor.sh
bash user_info.sh

}

menu() {
echo "1. Run All"
echo "2. System Check"
echo "3. Backup"
echo "4. Exit"

}

while true; do
    menu
   read -p "Choose Option: " choice
   case $choice in
	   1) run_all | tee -a "$LOG_FILE" ;;
	   2) bash system_check.sh | tee -a "$LOG_FILE" ;;
	   3) bash backup.sh . | tee -a "$LOG_FILE" ;;
	   4) exit 0 ;;
	   *) echo "Invalid Option" ;;

esac
done



































