#!/bin/bash

mkdir -p logs

# Get current date for log filename
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="logs/system_report_$DATE.log"

# Disk usage
echo "Disk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

# Warn if any disk usage >80%
df -h | awk 'NR>1 { if($5+0>80) print "WARNING: Disk "$6" usage is "$5 }' | tee -a $LOG_FILE

# Memory usage
echo -e "\nMemory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

# CPU load
echo -e "\nCPU Load:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

# Total running processes
echo -e "\nTotal Running Processes:" | tee -a $LOG_FILE
ps aux --no-heading | wc -l | tee -a $LOG_FILE

# Top 5 memory-consuming processes
echo -e "\nTop 5 Memory-Consuming Processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE