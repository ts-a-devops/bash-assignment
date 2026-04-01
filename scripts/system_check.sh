#!/bin/bash
# system_check.sh - Monitors system health and logs a report

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
DATE=$(date "+%Y-%m-%d")
LOG_FILE="$LOG_DIR/system_report_${DATE}.log"

echo "==============================="
echo "        SYSTEM HEALTH CHECK    "
echo "==============================="

# --- Disk Usage ---
echo ""
echo ">>> DISK USAGE (df -h):"
df -h

# Check if any partition exceeds 80%
echo ""
DISK_WARN=0
while IFS= read -r line; do
    USAGE=$(echo "$line" | awk '{print $5}' | tr -d '%')
    MOUNT=$(echo "$line" | awk '{print $6}')
    if [[ "$USAGE" =~ ^[0-9]+$ ]] && (( USAGE > 80 )); then
        echo "⚠️  WARNING: Disk usage on '$MOUNT' is at ${USAGE}% — exceeds 80%!"
        DISK_WARN=1
    fi
done < <(df -h | tail -n +2)

if (( DISK_WARN == 0 )); then
    echo "✅ All disk partitions are within safe usage limits."
fi

# --- Memory Usage ---
echo ""
echo ">>> MEMORY USAGE (free -m):"
free -m

# --- CPU Load ---
echo ""
echo ">>> CPU LOAD (uptime):"
uptime

# --- Running Processes ---
echo ""
PROCESS_COUNT=$(ps aux --no-header | wc -l)
echo ">>> TOTAL RUNNING PROCESSES: $PROCESS_COUNT"

# --- Top 5 Memory-Consuming Processes ---
echo ""
echo ">>> TOP 5 MEMORY-CONSUMING PROCESSES:"
ps aux --no-header --sort=-%mem | head -5 | awk '{printf "%-10s %-8s %-8s %s\n", $1, $2, $4"%", $11}'

# --- Save Report ---
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
{
    echo "===== SYSTEM REPORT: $TIMESTAMP ====="
    echo ""
    echo "-- DISK USAGE --"
    df -h
    echo ""
    echo "-- MEMORY USAGE --"
    free -m
    echo ""
    echo "-- CPU LOAD --"
    uptime
    echo ""
    echo "-- TOTAL PROCESSES: $PROCESS_COUNT --"
    echo ""
    echo "-- TOP 5 MEMORY PROCESSES --"
    ps aux --no-header --sort=-%mem | head -5
    echo "====================================="
} >> "$LOG_FILE"

echo ""
echo "Report saved to $LOG_FILE"
