#!/bin/bash

# Ensure logs directory exists
mkdir -p logs

# Get current date for log filename
DATE=$(date +%F)

# Define log file
LOG_FILE="logs/system_report_$DATE.log"

# Start writing report
echo "===== SYSTEM CHECK REPORT ($DATE) =====" > "$LOG_FILE"

# Disk usage information
echo "Disk Usage:" >> "$LOG_FILE"
df -h >> "$LOG_FILE"

# Memory usage
echo -e "\nMemory Usage:" >> "$LOG_FILE"
free -m >> "$LOG_FILE"

# CPU load (uptime shows load averages)
echo -e "\nCPU Load:" >> "$LOG_FILE"
uptime >> "$LOG_FILE"

# Extract disk usage percentage of root directory
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

# Warn if disk usage exceeds 80%
if (( USAGE > 80 )); then
    echo -e "\nWARNING: Disk usage is above 80%!" | tee -a "$LOG_FILE"
fi

# Count total running processes
echo -e "\nTotal Running Processes:" >> "$LOG_FILE"
ps aux | wc -l >> "$LOG_FILE"

# Show top 5 processes consuming most memory
echo -e "\nTop 5 Memory Consuming Processes:" >> "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 >> "$LOG_FILE"

# Final message to user
echo "System check completed. Report saved to $LOG_FILE"
