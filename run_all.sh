#!/usr/bin/bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log_dir="$script_dir/scripts/logs"
log_file="$log_dir/app.log"

mkdir -p "$log_dir"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$log_file"
}

	#Creating Functions

#Function 1
run_user_info() {
	log_message "Starting user_info.sh"

    if "$script_dir/scripts/user_info.sh"; then
        log_message "user_info.sh completed successfully"
    else
        log_message "user_info.sh failed"
    fi
}

#Function 2
run_system_check() {
    log_message "Starting system_check.sh"

    if "$script_dir/scripts/system_check.sh"; then
        log_message "system_check.sh completed successfully"
    else
        log_message "system_check.sh failed"
    fi
}

#Function 3
run_file_manager() {
	echo "File Manager options: create | delete | list | rename"
    read -rp "Enter file manager command: " command

    case "$command" in
        create)
            read -rp "Enter file name to create: " file_name
            if "$script_dir/scripts/file_manager.sh" create "$file_name"; then
                log_message "file_manager.sh create completed successfully"
            else
                log_message "file_manager.sh create failed"
            fi
            ;;
        delete)
            read -rp "Enter file name to delete: " file_name
            if "$script_dir/scripts/file_manager.sh" delete "$file_name"; then
                log_message "file_manager.sh delete completed successfully"
            else
                log_message "file_manager.sh delete failed"
            fi
            ;;
        list)
            read -rp "Enter file name to view: " file_name
            if "$script_dir/scripts/file_manager.sh" list "$file_name"; then
                log_message "file_manager.sh list completed successfully"
            else
                log_message "file_manager.sh list failed"
            fi
            ;;
        rename)
            read -rp "Enter current file name: " old_name
            read -rp "Enter new file name: " new_name
            if "$script_dir/scripts/file_manager.sh" rename "$old_name" "$new_name"; then
                log_message "file_manager.sh rename completed successfully"
            else
                log_message "file_manager.sh rename failed"
            fi
            ;;
        *)
            log_message "Invalid file manager command entered: $command"
            ;;
    esac
}

#Function 4
run_backup() {
	read -rp "Enter the directory you want to back up: " backup_dir

    if "$script_dir/scripts/backup.sh" "$backup_dir"; then
        log_message "backup.sh completed successfully"
    else
        log_message "backup.sh failed"
    fi
}

#Function 5
run_process_monitor() {
	read -rp "Enter service name to monitor (nginx, ssh, docker): " service_name

    if "$script_dir/scripts/process_monitor.sh" "$service_name"; then
        log_message "process_monitor.sh completed successfully"
    else
        log_message "process_monitor.sh failed"
    fi
}

run_all() {
	log_message "Starting Run All option"

    run_user_info
    run_system_check
    run_file_manager
    run_backup
    run_process_monitor

	log_message "Finished Run All option"
}

show_menu() {
    echo
    echo "===== DevOps Bash Toolkit Menu ====="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo
}

while true; do
    show_menu
    read -rp "Choose an option [1-4]: " choice

	case "$choice" in
        1)
            log_message "Running all scripts..."
            run_all
            ;;
        2)
            log_message "Running system check..."
            run_system_check
            ;;
        3)
            log_message "Running backup..."
            run_backup
            ;;
        4)
            log_message "Exiting application"
            break
            ;;
        *)
            log_message "Invalid option. Please choose 1, 2, 3, or 4."
            ;;
    esac
done
