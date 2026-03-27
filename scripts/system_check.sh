#!/bin/bash

# Create logs directory if it does not exist
mkdir -p ../logs

# Create log file with today's date
DATE=$(date +%F)
LOG_FILE="../logs/system_report_$DATE.log"

echo "===== SYSTEM CHECK REPORT =====" | tee -a $LOG_FILE
echo "Date: $(date)" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# Disk Usage
echo "---- Disk Usage ----" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# Memory Usage
echo "---- Memory Usage ----" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# CPU Load
echo "---- CPU Load ----" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# Check Disk Usage Warning
echo "---- Disk Usage Check ----" | tee -a $LOG_FILE

df -h | awk 'NR>1 {print $5 " " $6}' | while read output;
do
usage=$(echo $output | awk '{print $1}' | tr -d '%')
partition=$(echo $output | awk '{print $2}')

if [ $usage -ge 80 ]; then
echo "WARNING: Disk usage on $partition is above 80% ($usage%)" | tee -a $LOG_FILE
fi

done

echo "" | tee -a $LOG_FILE

# Count running processes
echo "---- Total Running Processes ----" | tee -a $LOG_FILE
ps aux | wc -l | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# Top 5 memory consuming processes
echo "---- Top 5 Memory Consuming Processes ----" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE
echo "===== END OF REPORT =====" | tee -a $LOG_FILE  
