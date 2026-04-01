
LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ── Default services array ───────────────
services=("nginx" "ssh" "docker")

# ── Check & attempt restart ──────────────
check_process() {
    local PROC="$1"

    if pgrep -x "$PROC" > /dev/null 2>&1; then
        echo "✅ [$PROC] Status: Running"
        log "[$PROC] Status: Running"
    else
        echo "❌ [$PROC] Status: Stopped — attempting restart..."
        log "[$PROC] Status: Stopped — attempting restart"

        # Attempt restart via systemctl (simulate if not available)
        if command -v systemctl &>/dev/null; then
            sudo systemctl start "$PROC" 2>/dev/null
        fi

        # Verify after restart attempt
        if pgrep -x "$PROC" > /dev/null 2>&1; then
            echo "🔄 [$PROC] Status: Restarted successfully"
            log "[$PROC] Status: Restarted successfully"
        else
            echo "⚠️  [$PROC] Status: Could not restart (simulated in this environment)"
            log "[$PROC] Status: Restart attempted — process still not running (may need elevated privileges)"
        fi
    fi
}

# ── Run for specific process or all defaults ──
if [[ -n "$1" ]]; then
    # Single process passed as argument
    check_process "$1"
else
    echo "========================================"
    echo "  PROCESS MONITOR — $(date '+%Y-%m-%d %H:%M:%S')"
    echo "  Monitoring: ${services[*]}"
    echo "========================================"
    for svc in "${services[@]}"; do
        check_process "$svc"
    done
    echo "========================================"
fi

