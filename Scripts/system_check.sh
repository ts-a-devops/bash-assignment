#!/usr/bin/env bash

# -----------------------------
# Configuration
# -----------------------------
LOG_DIR="logs"
DATE=$(date +"%Y-%m-%d")
LOG_FILE="$LOG_DIR/system_report_${DATE}.log"
DISK_THRESHOLD=80

mkdir -p "$LOG_DIR"

# -----------------------------
# Header
# -----------------------------
{
echo "====================================="
echo " System Health Report"
echo " Date: $(date)"
echo "====================================="
echo
} >> "$LOG_FILE"

# -----------------------------
# Disk Usage
# -----------------------------
{
echo ">>> Disk Usage (df -h)"
df -h
echo
} >> "$LOG_FILE"

# Warn if disk usage exceeds threshold
DISK_ALERT=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')
if (( DISK_ALERT > DISK_THRESHOLD )); then
  echo "WARNING: Disk usage exceeds ${DISK_THRESHOLD}% (Current: ${DISK_ALERT}%)" >> "$LOG_FILE"
fi

# -----------------------------
# Memory Usage
# -----------------------------
{
echo
echo ">>> Memory Usage (free -m)"
free -m
echo
} >> "$LOG_FILE"

# -----------------------------
# CPU Load
# -----------------------------
{
echo
echo ">>> CPU Load (uptime)"
uptime
echo
} >> "$LOG_FILE"

# -----------------------------
# Process Count
# -----------------------------
PROCESS_COUNT=$(ps -e --no-headers | wc -l)
echo "Total Running Processes: $PROCESS_COUNT" >> "$LOG_FILE"

# -----------------------------
# Top 5 Memory-Consuming Processes
# -----------------------------
{
echo
echo ">>> Top 5 Memory-Consuming Processes"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo
} >> "$LOG_FILE"

# -----------------------------
# Completion Notice
# -----------------------------
echo "Report saved to $LOG_FILE"
