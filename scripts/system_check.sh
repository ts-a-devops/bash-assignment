#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="../logs"
mkdir -p "$LOG_DIR"
DATE=$(date +%F)
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

echo "===== SYSTEM REPORT ($DATE) =====" | tee "$LOG_FILE"

df -h | tee -a "$LOG_FILE"

free -m | tee -a "$LOG_FILE"

uptime | tee -a "$LOG_FILE"

ps aux | wc -l | tee -a "$LOG_FILE"

ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

df -h | awk 'NR>1 {gsub("%",""); if ($5 > 80) print "WARNING: " $6}' | tee -a "$LOG_FILE"
