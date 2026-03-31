#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")/scripts"
LOG_DIR="$(dirname "$0")/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/app.log"

log_action() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

run_all() {
  log_action "Running ALL scripts..."
  run_system_check
  run_backup
  log_action "All scripts completed."
}

run_system_check() {
  echo ""
  echo "▶️  Running System Check..."
  log_action "Started: system_check.sh"
  if bash "$SCRIPT_DIR/system_check.sh"; then
    log_action "Completed: system_check.sh"
  else
    log_action "FAILED: system_check.sh"
    echo "❌ system_check.sh encountered an error."
  fi
}

run_backup() {
  echo ""
  read -rp "Enter directory to backup: " backup_dir
  echo "▶️  Running Backup for '$backup_dir'..."
  log_action "Started: backup.sh for '$backup_dir'"
  if bash "$SCRIPT_DIR/backup.sh" "$backup_dir"; then
    log_action "Completed: backup.sh"
  else
    log_action "FAILED: backup.sh"
    echo "❌ backup.sh encountered an error."
  fi
}

show_menu() {
  echo ""
  echo "========================================"
  echo "      DevOps Bash Toolkit Menu"
  echo "========================================"
  echo "  1. Run All Scripts"
  echo "  2. System Check"
  echo "  3. Backup"
  echo "  4. Exit"
  echo "========================================"
  read -rp "Choose an option [1-4]: " choice

  case "$choice" in
    1) run_all ;;
    2) run_system_check ;;
    3) run_backup ;;
    4)
      echo "👋 Exiting. Goodbye!"
      log_action "User exited the menu."
      exit 0
      ;;
    *)
      echo "❌ Invalid option. Please choose between 1 and 4."
      log_action "Invalid menu option entered: $choice"
      ;;
  esac
}

# Main loop
log_action "DevOps Bash Toolkit started."
while true; do
  show_menu
done

