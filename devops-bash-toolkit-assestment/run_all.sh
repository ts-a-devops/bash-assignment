#!/bin/bash
set -euo pipefail
# -e: exit on error | -u: error on unset variables | -o pipefail: catch pipe errors
# These 3 together are the professional standard for robust scripts

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"
SCRIPTS_DIR="scripts"
mkdir -p "$LOG_DIR"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

run_script() {
  local script="$SCRIPTS_DIR/$1"
  # local: variable scoped to this function only

  if [[ ! -f "$script" ]]; then
    # -f: true if path exists AND is a regular file
    log "ERROR: $script not found."
    return 1
    # return 1: exit the FUNCTION with error (not the whole script)
    # return vs exit: return exits the function, exit exits the entire script
  fi

  log "Running $script..."
  bash "$script" && log "$script completed." || log "ERROR: $script failed."
  # bash "$script": explicitly run with bash
  # &&: run right side only if left SUCCEEDED (exit code 0)
  # ||: run right side only if left FAILED (non-zero exit code)
}

run_all() {
  log "=== Running all scripts ==="
  run_script "user_info.sh"
  run_script "system_check.sh"
  run_script "file_manager.sh"
  run_script "backup.sh"
  run_script "process_monitor.sh"
}

menu() {
  echo ""
  echo "╔══════════════════════════════╗"
  echo "║     DevOps Toolkit Menu      ║"
  echo "╠══════════════════════════════╣"
  echo "║  1) Run All Scripts          ║"
  echo "║  2) System Check             ║"
  echo "║  3) Backup                   ║"
  echo "║  4) Exit                     ║"
  echo "╚══════════════════════════════╝"
  echo ""
  read -rp "Choose an option [1-4]: " choice
  # read -r: raw input | -p: show prompt before waiting
}

while true; do
  # while true: infinite loop — keeps showing the menu until user exits
  # true: a built-in command that always exits with code 0

  menu

  case "$choice" in
    1) run_all ;;
    2) run_script "system_check.sh" ;;
    3)
      read -rp "Enter directory to backup: " dir
      bash "$SCRIPTS_DIR/backup.sh" "$dir" || log "Backup failed."
      # Pass $dir as an argument to backup.sh
      ;;
    4)
      log "Exiting."
      echo "Goodbye! 👋"
      exit 0
      # exit 0: exit successfully (0 = success in Unix, anything else = error)
      ;;
    *)
      echo "Invalid option. Please choose 1–4."
      ;;
  esac
done
