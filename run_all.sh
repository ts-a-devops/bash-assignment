#!/bin/bash

# Interactive menu runner for all scripts

set -euo pipefail

# Check for batch mode
if [[ "${1:-}" == "--batch" ]]; then
    LOG_FILE="logs/app.log"
    mkdir -p "$(dirname "$LOG_FILE")"
    log_message() {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    }
    # Run all scripts in batch
    log_message "=== Batch Mode: Running All Scripts ==="
    echo "Running System Check..."
    bash scripts/system_check.sh 2>/dev/null || log_message "ERROR: system_check.sh failed"
    echo "System Check done."
    echo "Running User Info (skipped in batch mode)..."
    log_message "User Info script skipped in batch mode"
    echo "Running Process Monitor..."
    bash scripts/process_monitor.sh 2>/dev/null || log_message "ERROR: process_monitor.sh failed"
    echo "Process Monitor done."
    log_message "=== Batch Mode Completed ==="
    echo "All scripts executed in batch mode."
    exit 0
fi

LOG_FILE="logs/app.log"

mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

show_header() {
    clear
    echo "DEVOPS BASH TOOLKIT"
    echo "Interactive Automation Menu"
    echo ""
}

show_menu() {
    show_header
    echo "Select an option:"
    echo ""
    echo "  1) Run All Scripts"
    echo "  2) System Check"
    echo "  3) User Information"
    echo "  4) File Manager"
    echo "  5) Backup System"
    echo "  6) Process Monitor"
    echo "  7) View Logs"
    echo "  8) Exit"
    echo ""
}

run_user_info() {
    log_message "Executing: User Info Script"
    echo ""
    echo "=== User Information Script ==="
    
    if [[ -x "scripts/user_info.sh" ]]; then
        bash scripts/user_info.sh
    else
        echo "Error: scripts/user_info.sh not found or not executable"
        log_message "ERROR: scripts/user_info.sh not executable"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

run_system_check() {
    log_message "Executing: System Check Script"
    echo ""
    echo "=== System Check Report ==="
    
    if [[ -x "scripts/system_check.sh" ]]; then
        bash scripts/system_check.sh
    else
        echo "Error: scripts/system_check.sh not found or not executable"
        log_message "ERROR: scripts/system_check.sh not executable"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

run_file_manager() {
    log_message "Executing: File Manager Script"
    echo ""
    echo "=== File Manager ==="
    
    if [[ -x "scripts/file_manager.sh" ]]; then
        read -p "Enter file manager command (e.g., list, create file.txt): " -r cmd
        bash scripts/file_manager.sh $cmd
    else
        echo "Error: scripts/file_manager.sh not found or not executable"
        log_message "ERROR: scripts/file_manager.sh not executable"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

run_backup() {
    log_message "Executing: Backup Script"
    echo ""
    echo "=== Backup System ==="
    
    if [[ -x "scripts/backup.sh" ]]; then
        read -p "Enter directory to backup (e.g., .): " -r dir
        bash scripts/backup.sh "$dir"
    else
        echo "Error: scripts/backup.sh not found or not executable"
        log_message "ERROR: scripts/backup.sh not executable"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}


run_process_monitor() {
    log_message "Executing: Process Monitor Script"
    echo ""
    echo "=== Process Monitor ==="
    
    if [[ -x "scripts/process_monitor.sh" ]]; then
        read -p "Enter process name to monitor (leave blank for all): " -r process
        if [[ -z "$process" ]]; then
            bash scripts/process_monitor.sh
        else
            bash scripts/process_monitor.sh "$process"
        fi
    else
        echo "Error: scripts/process_monitor.sh not found or not executable"
        log_message "ERROR: scripts/process_monitor.sh not executable"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

run_all_scripts() {
    log_message "Executing: All Scripts"
    
    echo ""
    echo "Running all scripts in sequence..."
    echo ""
    
    echo "Running System Check..."
    bash scripts/system_check.sh 2>/dev/null || log_message "ERROR: system_check.sh failed"
    echo ""
    
    echo "Running User Info (skipped - requires user input)..."
    log_message "User Info script skipped in batch mode"
    echo ""
    
    echo "Running Process Monitor (all services)..."
    bash scripts/process_monitor.sh 2>/dev/null || log_message "ERROR: process_monitor.sh failed"
    echo ""
    
    log_message "All scripts executed"
    read -p "Press Enter to continue..."
}

view_logs() {
    show_header
    echo "=== Application Log ==="
    echo ""
    
    if [[ -f "$LOG_FILE" ]]; then
        tail -n 30 "$LOG_FILE"
    else
        echo "No logs found yet"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

log_message "=== Application Started ==="

while true; do
    show_menu
    read -p "Enter your choice [1-8]: " -r choice
    
    case "$choice" in
        1)
            run_all_scripts
            ;;
        2)
            run_system_check
            ;;
        3)
            run_user_info
            ;;
        4)
            run_file_manager
            ;;
        5)
            run_backup
            ;;
        6)
            run_process_monitor
            ;;
        7)
            view_logs
            ;;
        8)
            log_message "=== Application Terminated ==="
            echo "Exiting... Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            read -p "Press Enter to continue..."
            ;;
    esac
done

exit 0
