#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BACKUP_DIR="${PROJECT_ROOT}/backups"
LOG_DIR="${PROJECT_ROOT}/logs"
LOG_FILE="${LOG_DIR}/backup.log"

mkdir -p "${BACKUP_DIR}" "${LOG_DIR}"

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "${LOG_FILE}"
}

target_dir="${1:-}"

if [[ -z "${target_dir}" ]]; then
  message="Usage: ./backup.sh <directory>"
  echo "${message}"
  log_message "${message}"
  exit 1
fi

if [[ ! -d "${target_dir}" ]]; then
  message="Backup failed. Directory '${target_dir}' does not exist."
  echo "${message}"
  log_message "${message}"
  exit 1
fi

backup_file="${BACKUP_DIR}/backup_$(date +%Y%m%d_%H%M%S).tar.gz"
parent_dir="$(dirname "${target_dir}")"
base_name="$(basename "${target_dir}")"

tar -czf "${backup_file}" -C "${parent_dir}" "${base_name}"
message="Backup created: ${backup_file}"
echo "${message}"
log_message "${message}"

mapfile -t backups < <(ls -1t "${BACKUP_DIR}"/backup_*.tar.gz 2>/dev/null || true)

if (( ${#backups[@]} > 5 )); then
  for old_backup in "${backups[@]:5}"; do
    rm -f "${old_backup}"
    log_message "Deleted old backup: ${old_backup}"
  done
fi
