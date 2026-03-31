#!/usr/bin/env bash
# process_monitor.sh — Check / restart processes; monitors a default service list.
#
# Usage:
#   ./process_monitor.sh              # monitor all default services
#   ./process_monitor.sh <proc_name>  # monitor a single named process

set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
mkdir -p "$LOG_DIR"

# Default services array (required by spec)
services=("nginx" "ssh" "docker")

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] ${*:2}" | tee -a "$LOG_FILE"
}

# ── Check & attempt restart ───────────────────────────────────────────────────
check_process() {
    local proc="$1"

    if pgrep -x "$proc" &>/dev/null; then
        echo "  ✔ $proc — Running"
        log "INFO" "$proc: Running"
    else
        echo "  ✖ $proc — Stopped. Attempting restart..."
        log "WARN" "$proc: Stopped — attempting restart."

        # Real restart attempt (works if systemd is available)
        if command -v systemctl &>/dev/null; then
            if systemctl start "$proc" 2>/dev/null; then
                echo "  ↺ $proc — Restarted (systemctl)"
                log "INFO" "$proc: Restarted via systemctl."
            else
                echo "  ~ $proc — Restart simulated (systemctl unavailable or insufficient perms)"
                log "WARN" "$proc: Simulated restart (systemctl failed)."
            fi
        else
            # Simulate restart for environments without systemd
            echo "  ~ $proc — Restart simulated (no systemctl found)"
            log "WARN" "$proc: Simulated restart (no systemctl)."
        fi
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo ""
echo "===== Process Monitor — $(date '+%Y-%m-%d %H:%M:%S') ====="

if [[ $# -ge 1 ]]; then
    # Single process mode
    echo "Monitoring: $1"
    echo "-----------------------------"
    check_process "$1"
else
    # Default services array mode
    echo "Monitoring default services: ${services[*]}"
    echo "-----------------------------"
    for svc in "${services[@]}"; do
        check_process "$svc"
    done
fi

echo ""
echo "Log saved to: $LOG_FILE"
