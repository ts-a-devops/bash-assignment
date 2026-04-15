#!/bin/bash

LOG_FILE="logs/system_report_$(date +%Y-%m-%d).log"

mkdir -p logs

echo "System Check Report - $(date)" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# Disk usage
echo "Checking disk usage warnings..."

df -h | awk 'NR>1 {print $5, $1}' | while read line
do
  usage=$(echo $line | awk '{print $1}' | sed 's/%//')
  partition=$(echo $line | awk '{print $2}')

  # Ensure it's a number before comparing
  if [[ "$usage" =~ ^[0-9]+$ ]]; then
    if [ "$usage" -ge 80 ]; then
      echo "WARNING: $partition is at ${usage}% usage"
    fi
  fi
done

# Memory usage (Mac uses vm_stat instead of free)
echo "Memory Usage:" | tee -a "$LOG_FILE"
vm_stat | tee -a "$LOG_FILE"

# CPU load
echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Total running processes
echo "Total Running Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo "Top 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
ps aux | sort -nrk 4 | head -5 | tee -a "$LOG_FILE"