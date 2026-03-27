#!/bin/bash

# create logs directory
mkdir -p logs

# define log file with date
LOG_FILE="logs/system_report_$(date +%F).log"

# log everything automatically 
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== SYSTEM REPORT ====="
echo "Date: $(date)"
echo

# Disk usage
echo "---- Disk Usage ----"
df -h
echo

# Warning if disk > 80%
echo "---- Disk Warning Check ----"
df -h | awk 'NR>1 {gsub("%",""); if ($5 > 80) print "WARNING: " $1 " is at " $5 "%"}'
echo

# Memory usage
echo "---- Memory Usage ----"
free -m
echo

# CPU load
echo "---- CPU Load ----"
uptime
echo

# Total running processes
echo "---- Process Count ----"
ps aux | wc -l
echo

# Top 5 memory-consuming processes
echo "---- Top 5 Memory Consuming Processes ----"
ps aux --sort=-%mem | head -n 6
echo

echo "===== END OF REPORT ====="
