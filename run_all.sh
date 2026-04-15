#!/bin/bash
set -euo pipefail

# Create necessary directories
mkdir -p scripts logs

# Global log file
logfile="logs/app.log"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$logfile"
}

# Function to display banner
show_banner() {
    cat << "EOF"
========================================
    SYSTEM MANAGEMENT DASHBOARD
========================================
EOF
}

# Function to check if scripts exist
check_scripts() {
    local missing=0
    
    if [[ ! -f "scripts/user_info.sh" ]]; then
        echo "Warning: scripts/user_info.sh not found" >&2
        missing=1
    fi
    if [[ ! -f "scripts/system_report.sh" ]]; then
        echo "Warning: scripts/system_check.sh not found" >&2
        missing=1
    fi
    if [[ ! -f "scripts/file_manager.sh" ]]; then
        echo "Warning: scripts/file_manager.sh not found" >&2
        missing=1
    fi
    if [[ ! -f "scripts/backup.sh" ]]; then
        echo "Warning: scripts/backup.sh not found" >&2
        missing=1
    fi
    if [[ ! -f "scripts/process_monitor.sh" ]]; then
        echo "Warning: scripts/process_monitor.sh not found" >&2
        missing=1
    fi
    
    return $missing
}

# Function to run all scripts
run_all() {
    echo ""
    echo "========================================="
    echo "RUNNING ALL SCRIPTS"
    echo "========================================="
    log_action "Starting 'Run All' operation"
    
    # Run user_info.sh
    echo -e "\n[1/5] Running user_info.sh..."
    if [[ -f "scripts/user_info.sh" ]]; then
        bash scripts/user_info.sh
        log_action "Executed: user_info.sh"
    else
        echo "Skipped: user_info.sh not found"
        log_action "FAILED: user_info.sh not found"
    fi
    
    # Run system_check.sh
    echo -e "\n[2/5] Running system_check.sh..."
    if [[ -f "scripts/system_check.sh" ]]; then
        bash scripts/system_check.sh
        log_action "Executed: system_check.sh"
    else
        echo "Skipped: system_check.sh not found"
        log_action "FAILED: system_check.sh not found"
    fi
    
    # Run file_manager.sh (example: create a test file)
    echo -e "\n[3/5] Running file_manager.sh..."
    if [[ -f "scripts/file_manager.sh" ]]; then
        echo "  Creating test file..."
        bash scripts/file_manager.sh create test_$(date +%s).txt 2>/dev/null || true
        bash scripts/file_manager.sh list 2>/dev/null || true
        log_action "Executed: file_manager.sh"
    else
        echo "Skipped: file_manager.sh not found"
        log_action "FAILED: file_manager.sh not found"
    fi
    
    # Run backup.sh
    echo -e "\n[4/5] Running backup.sh..."
    if [[ -f "scripts/backup.sh" ]]; then
        # Backup current directory (or specify a test directory)
        mkdir -p test_backup_dir
        echo "Test content" > test_backup_dir/test.txt
        bash scripts/backup.sh test_backup_dir 2>/dev/null || true
        log_action "Executed: backup.sh"
    else
        echo "Skipped: backup.sh not found"
        log_action "FAILED: backup.sh not found"
    fi
    
    # Run process_monitor.sh
    echo -e "\n[5/5] Running process_monitor.sh..."
    if [[ -f "scripts/process_monitor.sh" ]]; then
        bash scripts/process_monitor.sh ssh 2>/dev/null || true
        log_action "Executed: process_monitor.sh"
    else
        echo "Skipped: process_monitor.sh not found"
        log_action "FAILED: process_monitor.sh not found"
    fi
    
    echo -e "\n✓ All scripts completed!"
    log_action "Completed 'Run All' operation"
}

# Function to run system check
system_check() {
    echo ""
    echo "========================================="
    echo "SYSTEM CHECK"
    echo "========================================="
    log_action "Starting 'System Check' operation"
    
    if [[ -f "scripts/system_check.sh" ]]; then
        bash scripts/system_check.sh
        log_action "Executed: system_check.sh"
    else
        echo "Error: scripts/system_check.sh not found"
        log_action "FAILED: system_check.sh not found"
        return 1
    fi
    
    log_action "Completed 'System Check' operation"
}

# Function to run backup
run_backup() {
    echo ""
    echo "========================================="
    echo "BACKUP OPERATION"
    echo "========================================="
    log_action "Starting 'Backup' operation"
    
    # Prompt for directory to backup
    read -p "Enter directory path to backup: " backup_dir
    
    if [[ -z "$backup_dir" ]]; then
        echo "Error: No directory provided. Using current directory."
        backup_dir="."
    fi
    
    if [[ -f "scripts/backup.sh" ]]; then
        bash scripts/backup.sh "$backup_dir"
        log_action "Executed: backup.sh for directory '$backup_dir'"
    else
        echo "Error: scripts/backup.sh not found"
        log_action "FAILED: backup.sh not found"
        return 1
    fi
    
    log_action "Completed 'Backup' operation"
}

# Function to display menu
show_menu() {
    echo ""
    echo "========================================="
    echo "          MAIN MENU"
    echo "========================================="
    echo "1. Run All Scripts"
    echo "2. System Check (Disk/Memory/CPU)"
    echo "3. Backup Directory"
    echo "4. Exit"
    echo "========================================="
    echo -n "Enter your choice [1-4]: "
}

# Main program loop
main() {
    show_banner
    
    # Check if scripts directory has required scripts
    check_scripts
    
    while true; do
        show_menu
        read choice
        
        case "$choice" in
            1)
                run_all
                ;;
            2)
                system_check
                ;;
            3)
                run_backup
                ;;
            4)
                echo ""
                echo "Exiting... Goodbye!"
                log_action "User exited the application"
                exit 0
                ;;
            *)
                echo "Error: Invalid choice. Please enter 1, 2, 3, or 4" >&2
                log_action "ERROR: Invalid menu choice '$choice'"
                ;;
        esac
        
        # Pause before showing menu again
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Trap Ctrl+C for clean exit
trap 'echo ""; echo "Interrupted by user"; log_action "Application interrupted (SIGINT)"; exit 0' INT

# Run main function
main
