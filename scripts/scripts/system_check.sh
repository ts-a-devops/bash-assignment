#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Create log file with date
log_file="logs/system_report_$(date +%Y-%m-%d).log"

echo "===== SYSTEM CHECK REPORT =====" | tee -a "$log_file"
echo "Date: $(date)" | tee -a "$log_file"
echo "" | tee -a "$log_file"

# Disk Usage
echo "---- Disk Usage ----" | tee -a "$log_file"
df -h | tee -a "$log_file"

# Check disk usage warning (>80%)
echo "" | tee -a "$log_file"
echo "---- Disk Warnings ----" | tee -a "$log_file"
df -h | awk 'NR>1 {gsub("%",""); if ($5 > 80) print "WARNING: " $1 " is at " $5 "%"}' | tee -a "$log_file"

# Memory Usage
echo "" | tee -a "$log_file"
echo "---- Memory Usage ----" | tee -a "$log_file"
free -m | tee -a "$log_file"

# CPU Load
echo "" | tee -a "$log_file"
echo "---- CPU Load ----" | tee -a "$log_file"
uptime | tee -a "$log_file"

# Total running processes
echo "" | tee -a "$log_file"
echo "---- Total Running Processes ----" | tee -a "$log_file"
ps aux | wc -l | tee -a "$log_file"

# Top 5 memory-consuming processes
echo "" | tee -a "$log_file"
echo "---- Top 5 Memory Consuming Processes ----" | tee -a "$log_file"
ps aux --sort=-%mem | head -n 6 | tee -a "$log_file"

echo "" | tee -a "$log_file"
echo "===== END OF REPORT =====" | tee -a "$log_file"
