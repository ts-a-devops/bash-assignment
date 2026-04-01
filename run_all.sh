#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/app.log"

mkdir -p "${LOG_DIR}"

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "${LOG_FILE}"
}

run_system_check() {
  log_message "Running system_check.sh"
  if ! "${SCRIPT_DIR}/scripts/system_check.sh"; then
    log_message "system_check.sh failed"
    echo "System check failed."
  fi
}

run_backup() {
  read -r -p "Enter directory to back up: " backup_target
  log_message "Running backup.sh for ${backup_target}"
  if ! "${SCRIPT_DIR}/scripts/backup.sh" "${backup_target}"; then
    log_message "backup.sh failed for ${backup_target}"
    echo "Backup failed."
  fi
}

run_all() {
  run_system_check
  run_backup
}

while true; do
  cat <<'EOF'
1. Run all
2. System check
3. Backup
4. Exit
EOF

  read -r -p "Choose an option: " choice

  case "${choice}" in
    1)
      log_message "Selected menu option: Run all"
      run_all
      ;;
    2)
      log_message "Selected menu option: System check"
      run_system_check
      ;;
    3)
      log_message "Selected menu option: Backup"
      run_backup
      ;;
    4)
      log_message "Selected menu option: Exit"
      echo "Goodbye."
      exit 0
      ;;
    *)
      log_message "Invalid menu option: ${choice}"
      echo "Invalid option. Please choose 1, 2, 3, or 4."
      ;;
  esac
done
