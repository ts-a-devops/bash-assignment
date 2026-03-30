#!/bin/bash

# Ensure logs directory exists
mkdir -p logs

# Create log file with date
log_file="logs/system_report_$(date +%Y%m%d_%H%M%S).log"

echo "===== SYSTEM REPORT =====" | tee -a "$log_file"
echo "Date: $(date)" | tee -a "$log_file"
echo "" | tee -a "$log_file"

# Disk usage
echo "Disk Usage:" | tee -a "$log_file"
df -h | tee -a "$log_file"

# Warn if disk usage > 80%
echo "" | tee -a "$log_file"
echo "Disk Usage Warnings:" | tee -a "$log_file"
df -h | awk '$5+0 > 80 {print "WARNING: High disk usage on " $6}' | tee -a "$log_file"

# Memory usage
echo "" | tee -a "$log_file"
echo "Memory Usage:" | tee -a "$log_file"
free -m | tee -a "$log_file"

# CPU load
echo "" | tee -a "$log_file"
echo "CPU Load:" | tee -a "$log_file"
uptime | tee -a "$log_file"

# Process count
echo "" | tee -a "$log_file"
echo "Total Running Processes:" | tee -a "$log_file"
ps aux | wc -l | tee -a "$log_file"

# Top 5 memory-consuming processes
echo "" | tee -a "$log_file"
echo "Top 5 Memory Consuming Processes:" | tee -a "$log_file"
ps aux --sort=-%mem | head -n 6 | tee -a "$log_file"

echo "" | tee -a "$log_file"
echo "Report saved to $log_file"
