#!/bin/bash

mkdir -p logs
DATE=$(date +%F)

echo "System Report - $DATE" > logs/system_report_$DATE.log

echo "Disk Usage:" >> logs/system_report_$DATE.log
df -h >> logs/system_report_$DATE.log

echo "Memory Usage:" >> logs/system_report_$DATE.log
free -m >> logs/system_report_$DATE.log

echo "CPU Load:" >> logs/system_report_$DATE.log
uptime >> logs/system_report_$DATE.log

echo "Top Processes:" >> logs/system_report_$DATE.log
ps aux --sort=-%mem | head -n 6 >> logs/system_report_$DATE.log

echo "Checking disk usage..."

df -h | awk '{if($5+0 > 80) print "Warning: High disk usage on " $1}'
