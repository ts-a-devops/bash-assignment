#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/system_report_$(date '+%Y-%m-%d').log"

DISK_THRESHOLD=80

generate_report() {
  echo "========================================"
  echo "  System Report - $(date '+%Y-%m-%d %H:%M:%S')"
  echo "========================================"

  echo ""
  echo "--- Disk Usage ---"
  df -h

  echo ""
  echo "--- Memory Usage (MB) ---"
  free -m

  echo ""
  echo "--- CPU Load ---"
  uptime

  echo ""
  echo "--- Disk Usage Warning Check ---"
  df -h | awk 'NR>1 {
    gsub(/%/, "", $5)
    if ($5+0 > '"$DISK_THRESHOLD"') {
      print "⚠️  WARNING: " $6 " is at " $5 "% usage (threshold: '"$DISK_THRESHOLD"'%)"
    }
  }'

  echo ""
  echo "--- Total Running Processes ---"
  echo "Total: $(ps aux --no-header | wc -l)"

  echo ""
  echo "--- Top 5 Memory-Consuming Processes ---"
  ps aux --no-header --sort=-%mem | head -5 | awk '{printf "%-10s %-8s %-8s %s\n", $1, $2, $4"%", $11}'

  echo ""
  echo "========================================"
}

report=$(generate_report)

echo "$report"
echo "$report" > "$LOG_FILE"
echo "✅ Report saved to $LOG_FILE"

