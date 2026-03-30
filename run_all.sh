#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_PATH="$SCRIPT_DIR/scripts"

mkdir -p "$LOG_DIR"

log_msg() {
  local level="$1"
  local msg="$2"
  printf "%s | %s | %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$msg" | tee -a "$LOG_FILE"
}

run_with_handling() {
  local label="$1"
  shift

  log_msg "INFO" "Running: $label"
  if "$@"; then
    log_msg "INFO" "Success: $label"
  else
    log_msg "ERROR" "Failed: $label"
  fi
}

run_all() {
  run_with_handling "user_info" bash "$SCRIPTS_PATH/user_info.sh"
  run_with_handling "system_check" bash "$SCRIPTS_PATH/system_check.sh"

  read -r -p "Enter directory for backup [default: .]: " backup_target
  backup_target="${backup_target:-.}"
  run_with_handling "backup" bash "$SCRIPTS_PATH/backup.sh" "$backup_target"

  if [[ -f "$SCRIPTS_PATH/process_monitor.sh" ]]; then
    read -r -p "Enter process name to monitor [default: nginx]: " process_name
    process_name="${process_name:-nginx}"
    run_with_handling "process_monitor" bash "$SCRIPTS_PATH/process_monitor.sh" "$process_name"
  fi
}

run_system_check() {
  run_with_handling "system_check" bash "$SCRIPTS_PATH/system_check.sh"
}

run_backup() {
  read -r -p "Enter directory for backup [default: .]: " backup_target
  backup_target="${backup_target:-.}"
  run_with_handling "backup" bash "$SCRIPTS_PATH/backup.sh" "$backup_target"
}

while true; do
  cat <<'EOF'

DevOps Bash Toolkit Menu
1. Run all
2. System check
3. Backup
4. Exit
EOF

  read -r -p "Choose an option [1-4]: " choice

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
      log_msg "INFO" "Exiting application"
      exit 0
      ;;
    *)
      log_msg "WARN" "Invalid option: $choice"
      ;;
  esac
done
