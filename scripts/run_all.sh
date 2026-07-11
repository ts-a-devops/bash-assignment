 #!/bin/bash


set -euo pipefail

log_file="logs/app.log"

#to log this message on screen and to the log file in an intaractive way
log_action() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}

run_system_check() {
	log_action "Starting system check..."
if ./system_check.sh; then
	log_action "System check completed successfully"
else
	log_action "ERROR: system_check.sh failed"
fi
}

#run backup.sh, handling failure gracefully
run_backup() {
	read -p "Enter the directory to back uo:" target_dir
	log_action "Starting backup of '$target_dir"
	if ./backup.sh "$target_dir"; then
		log_action "Backup completed successfully"
	else
		log_action "ERROR: backup.sh failed"
	fi
}

#run everything one after the other
run_all() {
	log_action "Running all tasks..."
	run_system_check
	run_backup
	log_action "All tasts finished"
}

show_menu() {
	    echo ""
	    echo "===== Main Menu ====="
	    echo "1. Run all"
            echo "2. System check"
            echo "3. Backup"
	    echo "4. Exit"
	    echo "======================"
            read -p "Choose an option (1-4): " choice
    }

# --- Main program loop ---
 main() {
     while true; do
             show_menu
              
      case "$choice" in
       1) run_all ;;
       2) run_system_check ;;
       3) run_backup;;                                                                     4) log_action "Exiting."
                                                                                
exit 0
;;
*)
	echo "Invalid option. Please choose 1-4"
	;;
esac
done
}

main
