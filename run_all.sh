#!/bin/bash
set -euo pipefail
mkdir -p logs
LOG_FILE="logs/app.log"

# Paths to scripts
SCRIPTS_DIR="./scripts"

# Directory to back up (adjust as needed)
BACKUP_DIR="./"  # You can change this to a specific folder

echo "===== DevOps Bash Toolkit Run All =====" | tee -a "$LOG_FILE"
echo "$(date): Started run_all.sh" >> "$LOG_FILE"

# Function to run user_info.sh
function run_user_info {
  echo -e "\n--- Running user_info.sh ---" | tee -a "$LOG_FILE"
  bash "$SCRIPTS_DIR/user_info.sh" | tee -a "$LOG_FILE"
}

# Function to run system_check.sh
function run_system_check {
  echo -e "\n--- Running system_check.sh ---" | tee -a "$LOG_FILE"
  bash "$SCRIPTS_DIR/system_check.sh" | tee -a "$LOG_FILE"
}

# Function to run backup.sh
function run_backup {
  echo -e "\n--- Running backup.sh ---" | tee -a "$LOG_FILE"
  bash "$SCRIPTS_DIR/backup.sh" "$BACKUP_DIR" | tee -a "$LOG_FILE"
}

# Function to run file_manager.sh (example: list files)
function run_file_manager {
  echo -e "\n--- Running file_manager.sh (list) ---" | tee -a "$LOG_FILE"
  bash "$SCRIPTS_DIR/file_manager.sh" list | tee -a "$LOG_FILE"
}

# Optional: process_monitor.sh (example with ssh)
function run_process_monitor {
  echo -e "\n--- Running process_monitor.sh (ssh) ---" | tee -a "$LOG_FILE"
  bash "$SCRIPTS_DIR/process_monitor.sh" ssh | tee -a "$LOG_FILE"
}

# Run everything
run_user_info
run_system_check
run_backup
run_file_manager
# Uncomment the next line if process_monitor.sh exists
# run_process_monitor

echo -e "\n===== Run Completed =====" | tee -a "$LOG_FILE"
echo "$(date): Finished run_all.sh" >> "$LOG_FILE"
