#!/bin/bash
set -euo pipefail
echo "Main Menu"


run_all() {
   ./scripts/file_manager.sh 
   ./scripts/process_monitor.sh 
   ./scripts/user_info.sh
   ./scripts/backup.sh
   ./scripts/system_check.sh
}

system_check() {
   ./scripts/system_check.sh
}

backup() {
   ./scripts/backup.sh
}
 
selection=0
echo "Select one of the following options: "
echo "1 - Run all"
echo "2 - System check"
echo "3 - Backup"
echo "4 - Exit"

while [ "$selection" -ne 4 ] 
do 
   read -p "Enter: " selection

   case $selection in  
      1)
      run_all
      echo "$(date) - User selected option 1" 2>&1 | tee -a ./scripts/logs/app.log
      ;;

      2)
      system_check
      echo "$(date) - User selected option 2" 2>&1 | tee -a ./scripts/logs/app.log
      ;;

      3)
      backup
      echo "$(date) - User selected option 3" 2>&1 | tee -a ./scripts/logs/app.log
      ;;

      4)
      echo "$(date) - User selected option 4. Exiting..." 2>&1 | tee -a ./scripts/logs/app.log
      break
      ;;
      
      *)
      echo "Invalid input. Valid inputs are 1-4" 2>&1 | tee -a ./scripts/logs/app.log

   esac
done