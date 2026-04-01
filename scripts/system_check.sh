#!/bin/bash

# ─────────────────────────────────────────
#  system_check.sh – System health report
# ─────────────────────────────────────────

LOG_DIR="$(dirname "$0")/../logs"
DATE=$(date '+%Y-%m-%d')
DATETIME=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="$LOG_DIR/system_report_${DATE}.log"
mkdir -p "$LOG_DIR"

DISK_WARN_THRESHOLD=80

# ── Helper ───────────────────────────────
section() { echo -e "\n===== $1 ====="; }

{
echo "========================================"
echo "  SYSTEM HEALTH REPORT — $DATETIME"
echo "========================================"

# ── Disk Usage ───────────────────────────
section "DISK USAGE"
df -h

# Warn if any filesystem exceeds threshold
while IFS= read -r line; do
    USAGE=$(echo "$line" | awk '{print $5}' | tr -d '%')
    MOUNT=$(echo "$line" | awk '{print $6}')
    if [[ "$USAGE" =~ ^[0-9]+$ ]] && (( USAGE > DISK_WARN_THRESHOLD )); then
        echo "⚠️  WARNING: Disk usage on '$MOUNT' is at ${USAGE}% (threshold: ${DISK_WARN_THRESHOLD}%)"
    fi
done < <(df -h | tail -n +2)

# ── Memory Usage ─────────────────────────
section "MEMORY USAGE (MB)"
free -m

# ── CPU Load ─────────────────────────────
section "CPU LOAD (uptime)"
uptime

# ── Running Processes ────────────────────
section "PROCESS COUNT"
PROC_COUNT=$(ps aux --no-headers | wc -l)
echo "Total running processes: $PROC_COUNT"

# ── Top 5 Memory-Consuming Processes ─────
section "TOP 5 MEMORY-CONSUMING PROCESSES"
ps aux --no-headers --sort=-%mem | head -5 | \
    awk '{printf "%-10s %-8s %-6s %-6s %s\n", $1, $2, $3, $4, $11}'

echo ""
echo "Report saved to: $LOG_FILE"
echo "========================================"
} | tee "$LOG_FILE"

