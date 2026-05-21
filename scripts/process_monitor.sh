#!/bin/bash
# =============================================================================
# process_monitor.sh - Monitor processes and attempt restart if not running
# Usage: ./process_monitor.sh [process_name]
#        (no argument = monitor the built-in services array)
# =============================================================================

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

mkdir -p "$LOG_DIR"

# ── Built-in services to monitor when no argument is given ───────────────────
services=("nginx" "ssh" "docker")

# ── Helper: timestamped log ───────────────────────────────────────────────────
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ── Helper: check if a process is running ────────────────────────────────────
is_running() {
    local proc="$1"
    # pgrep matches process name; suppress output
    pgrep -x "$proc" &>/dev/null
}

# ── Helper: attempt to restart a service ─────────────────────────────────────
attempt_restart() {
    local proc="$1"
    echo "  ⟳  Attempting to restart '$proc' …"

    # Try systemctl first (Linux with systemd), then service, then simulate
    if command -v systemctl &>/dev/null && systemctl list-units --type=service --all 2>/dev/null \
            | grep -q "${proc}.service"; then
        if systemctl restart "$proc" 2>/dev/null; then
            return 0
        fi
    elif command -v service &>/dev/null; then
        if service "$proc" restart 2>/dev/null; then
            return 0
        fi
    fi

    # Simulation fallback (Git Bash / environments without service managers)
    echo "  ℹ  No service manager found — simulating restart of '$proc'."
    sleep 1       # simulate restart delay
    return 1      # report as "simulated" (still stopped)
}

# ── Helper: monitor a single process ─────────────────────────────────────────
monitor_process() {
    local proc="$1"
    echo "  ────────────────────────────────────────"
    echo "  Process : $proc"

    if is_running "$proc"; then
        echo "  Status  : ✔  Running"
        log "MONITOR — '$proc' is Running."
    else
        echo "  Status  : ✖  Stopped"
        log "MONITOR — '$proc' is Stopped. Attempting restart …"

        if attempt_restart "$proc"; then
            # Brief pause then re-check
            sleep 2
            if is_running "$proc"; then
                echo "  Status  : ✔  Restarted successfully."
                log "MONITOR — '$proc' was Restarted successfully."
            else
                echo "  Status  : ✖  Restart attempted but process still not running."
                log "MONITOR — '$proc' restart attempted; still not running."
            fi
        else
            echo "  Status  : ℹ  Restart simulated (service manager unavailable)."
            log "MONITOR — '$proc' restart simulated."
        fi
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo "============================================"
echo "       Process Monitor — $(date '+%H:%M:%S')"
echo "============================================"

if [[ $# -ge 1 ]]; then
    # Single process passed as argument
    monitor_process "$1"
else
    # No argument — iterate over the built-in services array
    echo "  Monitoring built-in services array …"
    for svc in "${services[@]}"; do
        monitor_process "$svc"
    done
fi

echo "  ────────────────────────────────────────"
echo "  Log saved to: $LOG_FILE"
echo "============================================"