#!/bin/bash

set -euo pipefail


mkdir -p logs
LOG_FILE="logs/app.log"


log_action() {

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}



run_user_info() {

    log_action "Running user_info.sh"
    ./scripts/user_info.sh || log_action "user_info.sh failed"
}

run_system_check() {

    log_action "Running system_check.sh"
    ./scripts/system_check.sh || log_action "system_check.sh failed"
}


run_backup() {

   read -p "Enter directory to backup:" dir
   log_action "Running backup.sh for directory: $dir"
   ./scripts/backup.sh "$dir" || log_action "backup.sh failed for $dir"
}


run_all() {

    run_user_info
    run_system_check
    run_backup
}


while true; do

     echo
     echo "===== Bash Assignment Menu ====="
     echo "1. Run all"
     echo "2. System check"
     echo "3. Backup"
     echo "4. Exit"
     read -p "Choose an option:" choice

     case "$choice" in

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
	 log_action "Exiting application"
	 echo "Goodbye!"
	 exit 0
	 ;;

       *)
	 echo "Invalid option. Please choose 1-4."
	 log_action "Invalid menu option selected: $choice"
	 ;;

       esac
done

