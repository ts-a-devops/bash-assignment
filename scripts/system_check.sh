#!/bin/bash

# Create logs folder if it doesn't exist
mkdir -p logs

# Timestamp for log file
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="logs/system_report_$DATE.log"

echo "===== SYSTEM REPORT =====" | tee -a "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# =======================
# DISK USAGE
# =======================
echo "===== DISK USAGE =====" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# Check disk usage warning (>80%)
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 80 ]; then
  echo "WARNING: Disk usage is above 80% ($DISK_USAGE%)" | tee -a "$LOG_FILE"
fi

echo "" | tee -a "$LOG_FILE"

# =======================
# MEMORY USAGE
# =======================
echo "===== MEMORY USAGE =====" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# =======================
# CPU LOAD
# =======================
echo "===== CPU LOAD =====" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# =======================
# PROCESS COUNT
# =======================
echo "===== TOTAL RUNNING PROCESSES =====" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# =======================
# TOP 5 MEMORY PROCESSES
# =======================
echo "===== TOP 5 MEMORY-CONSUMING PROCESSES =====" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

echo "Report saved to: $LOG_FILE"
