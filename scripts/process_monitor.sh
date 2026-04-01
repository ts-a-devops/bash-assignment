#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/process_monitor.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

PROCESS="$1"

log "Monitoring process: ${PROCESS}"

if pgrep -x "${PROCESS}" > /dev/null; then
    echo "${PROCESS} is Running"
    log "${PROCESS} is running"
else
    echo "${PROCESS} is Stopped"
    log "${PROCESS} is not running - attempting restart simulation"
    
    # Simulate restart (in real life: systemctl restart or similar)
    echo "Simulating restart of ${PROCESS}..."
    sleep 1  # placeholder
    echo "${PROCESS} Restarted (simulated)"
    log "${PROCESS} restarted (simulated)"
fi
