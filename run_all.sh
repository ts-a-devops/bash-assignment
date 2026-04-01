#!/usr/bin/env bash
# run_all.sh - Interactive menu to run toolkit scripts
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)/scripts"
LOG_DIR="$(cd "$(dirname "$0")" && pwd)/logs"
LOG_FILE="$LOG_DIR/app.log"
mkdir -p "$LOG_DIR"


log() {
  local level=$1; shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" >> "$LOG_FILE"
}


run_script() {
  local script="$SCRIPT_DIR/$1"
  shift
  if [[ ! -f "$script" ]]; then
    echo "  Script not found: $script"
    log "ERROR" "Script not found: $script"
    return 1
  fi
  echo
  log "INFO" "Running: $script $*"
  if bash "$script" "$@"; then
    log "INFO" "Completed: $script"
  else
    echo "   Script exited with errors. Check logs for details."
    log "ERROR" "Failed: $script (exit $?)"
  fi
}


menu_system_check() {
  echo "   Running system check..."
  run_script system_check.sh
}

menu_backup() {
  read -rp "  Enter directory to back up: " BACKUP_SRC
  run_script backup.sh "$BACKUP_SRC"
}

menu_user_info() {
  echo "  Collecting user info..."
  run_script user_info.sh
}

menu_file_manager() {
  echo "Available commands: create | delete | list | rename"
  read -rp "Command: " FM_CMD
  read -rp "Argument(s): " FM_ARGS
  # shellcheck disable=SC2086
  run_script file_manager.sh "$FM_CMD" $FM_ARGS
}

menu_process_monitor() {
  read -rp "Process name(s) to monitor (blank for defaults): " PROCS
  if [[ -z "$PROCS" ]]; then
    run_script process_monitor.sh
  else
    # shellcheck disable=SC2086
    run_script process_monitor.sh $PROCS
  fi
}

menu_run_all() {
  echo "  Running all scripts..."
  echo
  echo "─── System Check ───────────────────────"
  run_script system_check.sh

  echo
  echo "─── Process Monitor ────────────────────"
  run_script process_monitor.sh

  echo
  echo "─── User Info ──────────────────────────"
  run_script user_info.sh
}

clear
log "INFO" "run_all.sh started"

while true; do
  echo

  echo "  1. Run All Scripts                  "
  echo "  2. System Check                     "
  echo "  3. Backup Directory                 "
  echo "  4. User Info                        "
  echo "  5. File Manager                     "
  echo "  6. Process Monitor                  "
  echo "  7. Exit                             "
  read -rp "Select an option [1-7]: " CHOICE

  case "$CHOICE" in
    1) menu_run_all        ;;
    2) menu_system_check   ;;
    3) menu_backup         ;;
    4) menu_user_info      ;;
    5) menu_file_manager   ;;
    6) menu_process_monitor;;
    7)
      echo "  Goodbye!"
      log "INFO" "run_all.sh exited by user"
      exit 0
      ;;
    *)
      echo " Invalid option. Please choose 1–7."
      ;;
  esac
done
