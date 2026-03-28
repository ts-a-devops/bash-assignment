#!/bin/bash

DATE=$(date +%Y-%m-%d)
LOG_FILE="../logs/system_report_$DATE.log"
mkdir -p ../logs

echo "System Report - $DATE" | tee -a "$LOG_FILE"
echo "----------------------" | tee -a "$LOG_FILE"

# Disk usage 
echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Memory usage
echo "Memory usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
echo"" | tee -a "$LOG_FILE"
echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Disk Usage Warning Check:" | tee -a "$LOG_FILE"

df -h | awk 'NR>1 {print $5 " " $1}' | while read output;
do
  usage=$(echo $output | awk '{print $1}' | sed 's/%//g')
  partition=$(echo $output | awk '{print $2}')

  if [ $usage -ge 80 ]; then
    echo "WARNING: $partition is at ${usage}% usage!" | tee -a "$LOG_FILE"
  fi
done

echo "" | tee -a "$LOG_FILE"
echo "Total Running Processes:" | tee -a "$LOG_FILE"

ps aux | wc -l | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Top 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"

ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
