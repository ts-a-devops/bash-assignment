#!/bin/bash

# Get current date
date_now=$(date +%F)

log_file="../logs/system_report_$date_now.log"

echo "System Check Report - $date_now" > "$log_file"
echo "-----------------------------" >> "$log_file"

# Disk usage
echo "Disk Usage:" | tee -a "$log_file"
df -h | tee -a "$log_file"

# Memory usage (Mac alternative to free -m)
echo "Memory Usage:" | tee -a "$log_file"
vm_stat | tee -a "$log_file"

# CPU load
echo "CPU Load:" | tee -a "$log_file"
uptime | tee -a "$log_file"

# Check disk usage warning
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$usage" -gt 80 ]; then
  echo "WARNING: Disk usage is above 80%!" | tee -a "$log_file"
fi

# Count processes
echo "Total running processes:" | tee -a "$log_file"
ps aux | wc -l | tee -a "$log_file"

# Top 5 memory consuming processes
echo "Top 5 memory-consuming processes:" | tee -a "$log_file"
ps aux | sort -nrk 4 | head -5 | tee -a "$log_file"
