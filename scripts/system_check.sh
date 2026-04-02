#!/bin/bash


D#ATE=$(date +"%Y-%m-%d")
DATE=$(date +"%Y-%m-%d")
LOG_FILE="../logs/system_report_$DATE.log"
mkdir -p "$(dirname "$LOG_FILE")"

echo "===================================================================="
echo "                      SYSTEM RESOURCE MONITOR                       " | tee -a "$LOG_FILE"
echo "===================================================================="
echo ""
df -h | tee -a "$LOG_FILE"

echo ""

echo "************************ Memory Usage ************************" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo ""

echo "************************ CPU Load ************************" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo ""

# Disk warning
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if (( USAGE > 80 )); then
  echo "WARNING: Disk usage is above 80%" | tee -a "$LOG_FILE"
fi

echo ""

# Process count
echo "************************ Running processes: $(ps aux | wc -l)" | tee -a "$LOG_FILE"

echo ""

# Top 5 memory-consuming processes
echo "************************ Top 5 memory-consuming processes ************************" | tee -a "$LOG_FILE"
 ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
