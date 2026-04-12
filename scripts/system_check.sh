#!/bin/bash

LOG_DIR="../logs"
DATE=$(date +"%Y-%m-%d")
LOG_FILE="$LOG_DIR/ system_report_$DATE.log"

mkdir -p $LOG_DIR

echo "System Report - $DATE" | tee $LOG_FILE
echo "-----------------------" | tee -a $LOG_FILE

echo "Disk Usage:" |  tee -a $LOG_FILE  
df -h | tee -a $LOG_FILE 

echo  "" | tee -a  $LOG_FILE
echo "Memory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE
echo  "CPU Load:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE
echo "Total Running Processes:" | tee -a
$LOG_FILE
ps aux | wc -l | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE
echo "Top 5 Memory Consuming Processes:" 
| tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE

usage=$(df / | awk 'NR==2 {print $5}' |
sed 's/%//')

if [ "$usage" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%" | tee -a $LOG_FILE
fi



