#!/bin/bash

set -euo pipefail

LOG_FILE="../logs/system_report_$(date +%F).log"

mkdir -p "$(dirname "$LOG_FILE")"

echo "===== SYSTEM REPORT =====" | tee -a "$LOG_FILE"

# -------------------------
# Disk Usage
# -------------------------
echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Correct disk usage parsing
df -h | awk 'NR>1 {print $5, $1}' | while read -r usage partition; do
  usage=${usage%\%}

  if [[ "$usage" =~ ^[0-9]+$ ]] && (( usage > 80 )); then
    echo "WARNING: $partition usage is above 80%" | tee -a "$LOG_FILE"
  fi
done

# -------------------------
# Memory Usage
# -------------------------
echo "Memory Usage:" | tee -a "$LOG_FILE"

if command -v free >/dev/null 2>&1; then
  free -m | tee -a "$LOG_FILE"
else
  echo "Memory info not available (non-Linux system)" | tee -a "$LOG_FILE"
fi

# -------------------------
# CPU Load
# -------------------------
echo "CPU Load:" | tee -a "$LOG_FILE"

if command -v uptime >/dev/null 2>&1; then
  uptime | tee -a "$LOG_FILE"
else
  echo "CPU load not available (non-Linux system)" | tee -a "$LOG_FILE"
fi

# -------------------------
# Process Count
# -------------------------
echo "Total Processes:" | tee -a "$LOG_FILE"
ps | wc -l | tee -a "$LOG_FILE"

# -------------------------
# Top Processes
# -------------------------
echo "Top 5 Processes:" | tee -a "$LOG_FILE"

if ps aux >/dev/null 2>&1; then
  ps aux | head -n 6 | tee -a "$LOG_FILE"
else
  ps | head -n 6 | tee -a "$LOG_FILE"
fi
