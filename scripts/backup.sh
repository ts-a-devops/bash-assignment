#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="logs"
BACKUP_DIR="backups"
mkdir -p "${LOG_DIR}" "${BACKUP_DIR}"

LOG_FILE="${LOG_DIR}/backup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

SOURCE_DIR="$1"

if [[ ! -d "${SOURCE_DIR}" ]]; then
    log "ERROR: Directory does not exist - ${SOURCE_DIR}"
    echo "Error: '${SOURCE_DIR}' is not a valid directory."
    exit 1
fi

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

log "Starting backup of ${SOURCE_DIR}..."

tar -czf "${BACKUP_FILE}" -C "$(dirname "${SOURCE_DIR}")" "$(basename "${SOURCE_DIR}")"

log "Backup completed: ${BACKUP_FILE}"

# Keep only last 5 backups
cd "${BACKUP_DIR}" || exit 1
ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -I {} rm -- "{}" 2>/dev/null || true

log "Old backups cleaned (keeping last 5)"

echo "Backup created: ${BACKUP_FILE}"
