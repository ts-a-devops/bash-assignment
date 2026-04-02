#!/bin/bash
set -u  # Keep strict, but avoid breaking full runs

LOG_FILE="../logs/app.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
  echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Safe script runner
run_script() {
  local script=$1
  shift

  if [[ -f "$SCRIPT_DIR/$script" ]]; then
    log "Running $script..."
    if bash "$SCRIPT_DIR/$script" "$@"; then
      log "$script completed successfully"
    else
      log "$script failed"
    fi
  else
    log "Script not found: $script"
  fi
}

run_all() {
  log "Running all tasks..."

  run_script "file_manager.sh" list
  run_script "system_check.sh"
  run_script "backup.sh" .
  run_script "process_monitor.sh"
  run_script "user_info.sh"

  log "All tasks completed"
}

menu() {
  echo "================================="
  echo "           MAIN MENU             "
  echo "================================="
  echo "1. Run all tasks"
  echo "2. System check"
  echo "3. Backup current directory"
  echo "4. Monitor system processes"
  echo "5. Get user information"
  echo "6. Exit"
  echo "================================="
}

while true; do
  menu
  read -p " Choose option: " choice
  echo ""
  case "$choice" in
    1) run_all ;;
    2) run_script "system_check.sh" ;;
    3) run_script "backup.sh" . ;;
	4)run_script "process_monitor.sh" ;;
    5)run_script "user_info.sh" ;;
    6) log "Exiting..."; exit 0 ;;
    *) echo "Invalid option. Try again." ;;
  esac

  echo
done
