#!/bin/bash

set -euo pipefail

# Create logs directory
mkdir -p logs

LOGFILE="logs/app.log"

# Function to log actions
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOGFILE"
}

# Function to run a script safely
run_script() {
    local script="$1"
    local description="$2"
    
    echo ""
    echo "=== Running: $description ==="
    echo "----------------------------------------"
    
    if [ -x "scripts/$script" ]; then
        if "scripts/$script"; then
            echo " $description completed successfully."
            log_action "SUCCESS - Ran $script"
        else
            echo " $description completed with errors."
            log_action "FAILED - $script exited with error"
        fi
    else
        echo " Script scripts/$script not found or not executable."
        log_action "ERROR - Script not found: $script"
    fi
    echo "----------------------------------------"
}

show_menu() {
    clear
    echo "============================================"
    echo "              Main Menu"
    echo "============================================"
    echo ""
    echo "1. Run All Scripts"
    echo "2. User Information"
    echo "3. System Check"
    echo "4. File Manager (demo)"
    echo "5. Backup (demo)"
    echo "6. Process Monitor"
    echo "7. View Logs"
    echo "8. Exit"
    echo ""
    echo "============================================"
}

while true; do
    show_menu
    read -rp "Enter your choice (1-8): " choice
    
    case $choice in
        1)
            echo "Running all scripts..."
            log_action "START - Running all scripts"
            
            run_script "user_info.sh" "User Information Tool"
            run_script "system_check.sh" "System Health Check"
            
            # For file_manager and backup, we provide demo usage since they need arguments
            echo ""
            echo "=== File Manager Demo ==="
            echo "Running: ./scripts/file_manager.sh create test_demo.txt"
            scripts/file_manager.sh create test_demo.txt || true
            echo ""
            
            echo "=== Backup Demo ==="
            echo "Running: ./scripts/backup.sh scripts"
            scripts/backup.sh scripts || true
            
            run_script "process_monitor.sh" "Process Monitor"
            
            log_action "COMPLETE - All scripts execution finished"
            echo ""
            echo "All scripts have been executed."
            read -rp "Press Enter to continue..."
            ;;
            
        2)
            run_script "user_info.sh" "User Information Tool"
            read -rp "Press Enter to continue..."
            ;;
            
        3)
            run_script "system_check.sh" "System Health Check"
            read -rp "Press Enter to continue..."
            ;;
            
        4)
            echo "File Manager - Interactive Demo"
            echo "Available commands: create, delete, list, rename"
            read -rp "Enter file_manager command (e.g. create demo.txt): " fm_cmd
            if [ -n "$fm_cmd" ]; then
                scripts/file_manager.sh $fm_cmd || true
            fi
            read -rp "Press Enter to continue..."
            ;;
            
        5)
            echo "Backup Demo"
            read -rp "Enter directory to backup (default: scripts): " backup_dir
            backup_dir=${backup_dir:-scripts}
            scripts/backup.sh "$backup_dir" || true
            read -rp "Press Enter to continue..."
            ;;
            
        6)
            run_script "process_monitor.sh" "Process Monitor"
            read -rp "Press Enter to continue..."
            ;;
            
        7)
            echo "=== Recent Logs ==="
            if [ -f "$LOGFILE" ]; then
                tail -n 50 "$LOGFILE"
            else
                echo "No logs found yet."
            fi
            echo ""
            echo "Individual script logs are in the logs/ directory."
            read -rp "Press Enter to continue..."
            ;;
            
        8)
            echo "Exiting Bash Automation Toolkit. Goodbye!"
            log_action "EXIT - User exited the menu"
            exit 0
            ;;
            
        *)
            echo "Invalid choice. Please select 1-8."
            read -rp "Press Enter to continue..."
            ;;
    esac
done
