#!/bin/bash

# Create logs directory
mkdir -p ../logs

# Log file with date
log_file="../logs/system_report_$(date +%F).log"

echo "system report - $(date)" | tee -a "$log_file"
echo "----------------------------------" | tee -a "$log_file"

# Disk usage
echo "Disk Usage:" | tee -a "$log_file"
df -h | tee -a "$log__file"

# Memory usage
echo "" | tee -a "$log_file"
echo "Memory Usage:" | tee -a "$log_file"
free -m | tee -a "$log_file"

# CPU load
echo "" | tee -a "$log_file"
echo "CPU Load:"| tee -a "$log_file"
uptime | tee -a "$log_file"

# Runing processes
echo "" | tee -a "$log_file" 
echo "Total Running Processes:" | tee -a "$log_file"
ps aux | wc -l | tee -a "$log_file"

# Top memory processes
echo "" | tee -a "$log_file"
echo "Top 5 Memory-Consuming Processes:" | tee -a "$log_file"
ps aux --sort=-%mem | head -n 6 | tee -a "$log_file"

# Disk warning
echo "" | tee -a "$log_file"
echo "Disk Usage Warnings:" | tee -a "$log_file"
df -h | awk '$5+0 > 80 {print "Warning: " $0}' | tee -a "$log_file"

