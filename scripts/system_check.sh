#!/bin/bash
# =============================================================================
# system_check.sh - Display system health info and save a dated report
# =============================================================================

LOG_DIR="$(dirname "$0")/../logs"
REPORT_FILE="$LOG_DIR/system_report_$(date '+%Y-%m-%d').log"
DISK_WARN_THRESHOLD=80

mkdir -p "$LOG_DIR"

# ── Helper: write to both stdout and the report file ─────────────────────────
report() {
    echo "$1" | tee -a "$REPORT_FILE"
}

# ── Header ────────────────────────────────────────────────────────────────────
{
echo "============================================"
echo "   System Health Report — $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"
} | tee -a "$REPORT_FILE"

# ── 1. Disk Usage ─────────────────────────────────────────────────────────────
report ""
report "--- Disk Usage (df -h) ---"
df -h | tee -a "$REPORT_FILE"

# Check for any filesystem exceeding the threshold
report ""
report "--- Disk Usage Warnings (threshold: ${DISK_WARN_THRESHOLD}%) ---"
WARNED=false
while IFS= read -r line; do
    # Extract the use% column (field 5 on Linux, field 8 on macOS/Git-Bash)
    USE=$(echo "$line" | awk '{
        for(i=1;i<=NF;i++) {
            if ($i ~ /^[0-9]+%$/) { gsub(/%/,"",$i); print $i; exit }
        }
    }')
    MOUNT=$(echo "$line" | awk '{print $NF}')
    if [[ "$USE" =~ ^[0-9]+$ ]] && (( USE > DISK_WARN_THRESHOLD )); then
        MSG="  ⚠  WARNING: $MOUNT is at ${USE}% — exceeds ${DISK_WARN_THRESHOLD}% threshold!"
        report "$MSG"
        WARNED=true
    fi
done < <(df -h | tail -n +2)

$WARNED || report "  ✔  All filesystems are within safe limits."

# ── 2. Memory Usage ───────────────────────────────────────────────────────────
report ""
report "--- Memory Usage (free -m) ---"
if command -v free &>/dev/null; then
    free -m | tee -a "$REPORT_FILE"
else
    report "  ℹ  'free' is not available on this system (macOS/Windows native)."
fi

# ── 3. CPU Load ───────────────────────────────────────────────────────────────
report ""
report "--- CPU Load (uptime) ---"
uptime | tee -a "$REPORT_FILE"

# ── 4. Running Process Count ──────────────────────────────────────────────────
report ""
report "--- Running Processes ---"
PROC_COUNT=$(ps aux 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
report "  Total running processes: $PROC_COUNT"

# ── 5. Top 5 Memory-Consuming Processes ───────────────────────────────────────
report ""
report "--- Top 5 Memory-Consuming Processes ---"
printf "%-8s %-6s %-6s %-s\n" "PID" "%CPU" "%MEM" "COMMAND" | tee -a "$REPORT_FILE"
ps aux --sort=-%mem 2>/dev/null | awk 'NR>1 {printf "%-8s %-6s %-6s %-s\n", $2, $3, $4, $11}' \
    | head -5 | tee -a "$REPORT_FILE"

# ── Footer ────────────────────────────────────────────────────────────────────
report ""
report "============================================"
report "  Report saved to: $REPORT_FILE"
report "============================================"