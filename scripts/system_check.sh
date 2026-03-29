#!/bin/bash

mkdir -p logs
LOG_FILE="logs/system_report_$(date +%F).log"

echo "System Report" | tee -a $LOG_FILE

df -h | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

df -h | awk '$5+0 > 80 {print "WARNING: Disk usage high"}' | tee -a $LOG_FILE

ps aux | wc -l | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE
