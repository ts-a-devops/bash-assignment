#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="logs"
REPORT_DIR="logs"
mkdir -p "${LOG_DIR}" "${REPORT_DIR}"

DATE=$(date '+%Y%m%d_%H%M%S')
REPORT_FILE="${REPORT_DIR}/system_report_${DATE}.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_DIR}/system_check.log"
}

log "Starting system check..."

{
    echo "=== System Report - $(date) ==="
    echo "Disk Usage:"
    df -h
    echo -e "\nMemory Usage:"
    free -m
    echo -e "\nCPU Load:"
    uptime
    echo -e "\nTotal Running Processes: $(ps -e | wc -l)"

    echo -e "\nTop 5 Memory-Consuming Processes:"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6

    # Disk warning
    DISK_USAGE=$(df / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
    if [[ "${DISK_USAGE}" -gt 80 ]]; then
        echo "WARNING: Disk usage is high: ${DISK_USAGE}%"
        log "WARNING: Disk usage exceeded 80% (${DISK_USAGE}%)"
    fi
} | tee "${REPORT_FILE}"

log "System check completed. Report saved to ${REPORT_FILE}"
echo "System report saved to ${REPORT_FILE}"
