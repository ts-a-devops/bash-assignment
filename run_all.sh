#!/bin/bash
# This script provides an interactive menu to run DevOps toolkit scripts

# Exit immediately if a command fails (-e)
# Treat unset variables as an error (-u)
# Ensure pipelines fail if any command fails (pipefail)
set -euo pipefail


# -----------------------------
# CREATE REQUIRED DIRECTORIES
# -----------------------------

# Create logs folder if it does not exist
mkdir -p logs

# Create backups folder if it does not exist
mkdir -p backups


# -----------------------------
# LOG FILE SETUP
# -----------------------------

# Define the log file for the entire app
LOG_FILE="logs/app.log"


# Function to log messages into the app log file
log_action() {
  # $1 is the message passed into the function
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}


# -----------------------------
# FUNCTION: RUN SYSTEM CHECK
# -----------------------------
run_system_check() {

  # Print message to terminal
  echo "Running system check script..."

  # Log action
  log_action "INFO: Running system_check.sh"

  # Try to run the script safely
  if ./scripts/system_check.sh; then
    echo "System check completed successfully."
    log_action "SUCCESS: system_check.sh completed successfully."
  else
    echo "System check failed."
    log_action "ERROR: system_check.sh failed."
  fi
}


# -----------------------------
# FUNCTION: RUN BACKUP
# -----------------------------
run_backup() {

  # Ask user which directory to backup
  echo "Enter the directory you want to back up:"
  read -r DIR

  # Log the directory the user entered
  log_action "INFO: User requested backup for directory '$DIR'"

  # Run backup script safely
  if ./scripts/backup.sh "$DIR"; then
    echo "Backup completed successfully."
    log_action "SUCCESS: backup.sh completed successfully for '$DIR'"
  else
    echo "Backup failed."
    log_action "ERROR: backup.sh failed for '$DIR'"
  fi
}


# -----------------------------
# FUNCTION: RUN ALL SCRIPTS
# -----------------------------
run_all_scripts() {

  echo "Running ALL scripts..."
  log_action "INFO: Running all scripts"

  # Run user_info script
  if ./scripts/user_info.sh; then
    log_action "SUCCESS: user_info.sh completed successfully."
  else
    log_action "ERROR: user_info.sh failed."
  fi

  # Run system check script
  if ./scripts/system_check.sh; then
    log_action "SUCCESS: system_check.sh completed successfully."
  else
    log_action "ERROR: system_check.sh failed."
  fi

  # Ask user for backup directory before running backup
  echo "Enter directory to backup:"
  read -r DIR

  log_action "INFO: Running backup for '$DIR'"

  # Run backup script
  if ./scripts/backup.sh "$DIR"; then
    log_action "SUCCESS: backup.sh completed successfully."
  else
    log_action "ERROR: backup.sh failed."
  fi

  echo "All scripts completed."
  log_action "INFO: All scripts finished running."
}


# -----------------------------
# FUNCTION: SHOW MENU
# -----------------------------
show_menu() {

  # Print menu options
  echo "=============================="
  echo "   DevOps Bash Toolkit Menu   "
  echo "=============================="
  echo "1. Run all"
  echo "2. System check"
  echo "3. Backup"
  echo "4. Exit"
  echo "=============================="
}


# -----------------------------
# MAIN PROGRAM LOOP
# -----------------------------

# Keep showing the menu until user chooses Exit
while true; do

  # Show menu
  show_menu

  # Ask user for choice
  echo "Enter your choice (1-4):"
  read -r choice

  # Log the user choice
  log_action "INFO: User selected option '$choice'"

  # Check choice using case statement
  case $choice in

    1)
      run_all_scripts
      ;;

    2)
      run_system_check
      ;;

    3)
      run_backup
      ;;

    4)
      echo "Exiting... Goodbye!"
      log_action "INFO: User exited the application."
      exit 0
      ;;

    *)
      echo "Invalid option. Please choose 1-4."
      log_action "WARNING: Invalid option selected: '$choice'"
      ;;

  esac

  # Pause after each action so user can read output
  echo ""
  echo "Press Enter to continue..."
  read -r

done
