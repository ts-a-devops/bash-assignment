#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Define log file with current date
log_file="logs/system_report_$(date +%Y-%m-%d).log"

# Start logging
echo "System Report - $(date)" > "$log_file"
echo "----------------------------------------" >> "$log_file"

# Disk Usage
echo -e "\nDisk Usage:" | tee -a "$log_file"
df -h | tee -a "$log_file"

# Warn if disk usage exceeds 80%
echo -e "\nDisk Usage Warnings (>80%):" | tee -a "$log_file"
df -h | awk 'NR>1 {gsub("%","",$5); if($5 > 80) print "Warning: " $1 " is at " $5 "%"}' | tee -a "$log_file"

# Memory Usage
echo -e "\nMemory Usage (MB):" | tee -a "$log_file"
free -m | tee -a "$log_file"

# CPU Load
echo -e "\nCPU Load:" | tee -a "$log_file"
uptime | tee -a "$log_file"

# Total running processes
process_count=$(ps -e --no-headers | wc -l)
echo -e "\nTotal Running Processes: $process_count" | tee -a "$log_file"

# Top 5 memory-consuming processes
echo -e "\nTop 5 Memory-Consuming Processes:" | tee -a "$log_file"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tee -a "$log_file"

echo -e "\nReport saved to $log_file"
