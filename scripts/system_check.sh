#!/bin/bash

LOG_FILE="../logs/system_report_$(date +%F).log"

echo "==== System Check Loading...====" | tee -a "$LOG_FILE"

echo -e "\n==== Disk Usage ====" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo -e "\n==== Memory Usage ====" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo -e "\n==== CPU Load ====" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Disk usage check
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if (( usage > 80 )); then
    echo "WARNING: Disk usage is above 80%" | tee -a "$LOG_FILE"
fi

# Total processes
echo -e "\n==== Total Processes ====" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo -e "\n==== Top 5 Memory Consuming Processes ====" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"