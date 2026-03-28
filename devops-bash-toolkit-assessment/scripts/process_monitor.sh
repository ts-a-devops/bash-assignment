#!/usr/bin/env bash
# =============================================================================
# process_monitor.sh — Checks whether a process is running and attempts a
#                      simulated restart if it is stopped. Monitors a default
#                      list of services and logs all results.
#
# Usage:
#   ./process_monitor.sh [process_name]
#   ./process_monitor.sh          # monitors all default services
#   ./process_monitor.sh nginx    # monitors a single named process
# =============================================================================
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

# ── Default services to monitor when no argument is given ─────────────────────
services=("nginx" "ssh" "docker")

# ── Ensure log directory exists ───────────────────────────────────────────────
mkdir -p "$LOG_DIR"

# ── Logging helper ────────────────────────────────────────────────────────────
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# ── Check if a process is running ─────────────────────────────────────────────
# Returns 0 (true) if at least one matching process is found, 1 otherwise.
is_running() {
    local process_name="$1"
    # pgrep -x matches the exact process name; suppress output
    pgrep -x "$process_name" > /dev/null 2>&1
}

# ── Attempt to restart a service ─────────────────────────────────────────────
# Tries systemctl first (systemd), then falls back to a simulation message.
attempt_restart() {
    local process_name="$1"

    # Try systemctl if available (requires appropriate permissions)
    if command -v systemctl &>/dev/null; then
        log "INFO" "Attempting restart of '$process_name' via systemctl..."
        if systemctl restart "$process_name" 2>/dev/null; then
            log "INFO" "'$process_name' restarted successfully via systemctl."
            echo "  ✔  '$process_name' restarted via systemctl."
            return 0
        fi
    fi

    # Fallback: simulate restart (safe for environments without systemd/root)
    log "WARN" "Could not restart '$process_name' via systemctl. Simulating restart."
    echo "  ⚠  Simulated restart for '$process_name' (no systemctl access or service not found)."
    return 0
}

# ── Monitor a single process ──────────────────────────────────────────────────
monitor_process() {
    local process_name="$1"

    echo ""
    echo "  Checking: $process_name"
    echo "  ─────────────────────────────────"

    if is_running "$process_name"; then
        # Process found — report running status
        local pid
        pid="$(pgrep -x "$process_name" | head -1)"
        log "INFO" "'$process_name' is RUNNING (PID: $pid)"
        echo "  ✔  Status: RUNNING  (PID: $pid)"
    else
        # Process not found — report stopped and attempt restart
        log "WARN" "'$process_name' is STOPPED. Attempting restart..."
        echo "  ✗  Status: STOPPED"
        attempt_restart "$process_name"

        # Verify restart succeeded
        if is_running "$process_name"; then
            log "INFO" "'$process_name' is now RUNNING after restart."
            echo "  ✔  Status after restart: RUNNING"
        else
            log "ERROR" "'$process_name' could not be restarted."
            echo "  ✗  Status after restart: STILL STOPPED"
        fi
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
    log "INFO" "=== process_monitor.sh started ==="
    echo ""
    echo "╔══════════════════════════════════╗"
    echo "║       Process Monitor            ║"
    echo "╚══════════════════════════════════╝"

    if [[ $# -ge 1 ]]; then
        # Monitor the single process name provided as argument
        monitor_process "$1"
    else
        # No argument — iterate over the default services array
        log "INFO" "No process specified. Monitoring default services: ${services[*]}"
        echo ""
        echo "  Monitoring default services: ${services[*]}"
        for service in "${services[@]}"; do
            monitor_process "$service"
        done
    fi

    echo ""
    log "INFO" "=== process_monitor.sh completed ==="
}

main "$@"
