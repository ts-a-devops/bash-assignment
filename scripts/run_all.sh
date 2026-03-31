#!/bin/bash

# run_all.sh - Interactive menu to run various scripts
set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

LOG_FILE="logs/app.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to display menu
display_menu() {
    echo ""
    echo "=========================================="
    echo "   DevOps Bash Toolkit - Main Menu"
    echo "=========================================="
    echo "1. Run all scripts"
    echo "2. System check"
    echo "3. Backup directory"
    echo "4. User information"
    echo "5. Process monitor"
    echo "6. File manager"
    echo "7. Exit"
    echo "=========================================="
    echo ""
}

# Function to run user info script
run_user_info() {
    log_message "Running user_info.sh"
    if bash scripts/user_info.sh; then
        log_message "user_info.sh completed successfully"
    else
        log_message "Error: user_info.sh failed"
        return 1
    fi
}

# Function to run system check script
run_system_check() {
    log_message "Running system_check.sh"
    if bash scripts/system_check.sh; then
        log_message "system_check.sh completed successfully"
    else
        log_message "Error: system_check.sh failed"
        return 1
    fi
}

# Function to run backup script
run_backup() {
    log_message "Running backup.sh"
    read -p "Enter directory to backup: " backup_dir
    if bash scripts/backup.sh "$backup_dir"; then
        log_message "backup.sh completed successfully"
    else
        log_message "Error: backup.sh failed"
        return 1
    fi
}

# Function to run process monitor script
run_process_monitor() {
    log_message "Running process_monitor.sh"
    if bash scripts/process_monitor.sh; then
        log_message "process_monitor.sh completed successfully"
    else
        log_message "Error: process_monitor.sh failed"
        return 1
    fi
}

# Function to run file manager script
run_file_manager() {
    log_message "Running file_manager.sh"
    read -p "Enter command (create/delete/list/rename): " file_command
    
    case "$file_command" in
        create|delete)
            read -p "Enter filename: " filename
            bash scripts/file_manager.sh "$file_command" "$filename"
            ;;
        list)
            bash scripts/file_manager.sh list
            ;;
        rename)
            read -p "Enter old filename: " old_name
            read -p "Enter new filename: " new_name
            bash scripts/file_manager.sh rename "$old_name" "$new_name"
            ;;
        *)
            echo "Invalid command"
            log_message "Error: Invalid file manager command - $file_command"
            return 1
            ;;
    esac
}

# Function to run all scripts
run_all() {
    log_message "Running all scripts"
    
    run_system_check || {
        log_message "Warning: system_check.sh had issues, continuing..."
    }
    
    run_user_info || {
        log_message "Warning: user_info.sh had issues, continuing..."
    }
    
    run_process_monitor || {
        log_message "Warning: process_monitor.sh had issues, continuing..."
    }
    
    log_message "All scripts execution completed"
}

# Main menu loop
log_message "Application started"

while true; do
    display_menu
    read -p "Enter your choice (1-7): " choice
    
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
            run_user_info
            ;;
        5)
            run_process_monitor
            ;;
        6)
            run_file_manager
            ;;
        7)
            log_message "Application exited"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            log_message "Error: Invalid menu choice - $choice"
            ;;
    esac
done
