#!/bin/bash
DATE=$(date +"%Y")
LOG_FILE="../logs/system_report_$DATE.log"

echo "===My System Health Report===" | tee -a "$LOG_FILE" 
echo "===My Disk Report===" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "===My Computer Space==="
free -m | tee -a "$LOG_FILE"

echo "===My CPU Load==="
uptime | tee -a "$LOG_FILE"

#Warning Disk

USAGE=$(df / | awk 'NR==2 {print$5}' | sed 's/%//')

if [[ $USAGE -gt 80 ]]; then
    echo "Warning disk is above 80%" | tee -a "$LOG_FILE"
fi

echo "===Total processes running : $(ps aux | wc -l)" | tee -a "$LOG_FILE"
echo "---------- Top 5 memory-consuming processes ----------" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
