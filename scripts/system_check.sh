#!/usr/bin/env bash

# Setup directory and dynamic filename with current date
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
CURRENT_DATE=$(date '+%Y-%m-%d')
REPORT_FILE="$LOG_DIR/system_report_${CURRENT_DATE}.log"

# Tee output to both terminal and the dated log file
exec > >(tee -a "$REPORT_FILE") 2>&1

echo "=========================================="
echo "          SYSTEM HEALTH REPORT            "
echo "Generated at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

echo -e "\n--- 1. CPU LOAD (uptime) ---"
uptime

echo -e "\n--- 2. MEMORY USAGE (free -m) ---"
free -m

echo -e "\n--- 3. DISK USAGE (df -h) ---"
df -h /

# Check if root disk usage exceeds 80%
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "⚠️  ALERT: Root disk usage is above 80%! Current usage: ${DISK_USAGE}%"
else
    echo "Disk usage is normal: ${DISK_USAGE}%"
fi

echo -e "\n--- 4. TOTAL RUNNING PROCESSES ---"
TOTAL_PROCESSES=$(ps aux | wc -l)
echo "Total processes currently running: $((TOTAL_PROCESSES - 1))"

echo -e "\n--- 5. TOP 5 MEMORY-CONSUMING PROCESSES ---"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

echo -e "\n=========================================="
echo "Report successfully saved to: $REPORT_FILE"
echo "=========================================="
