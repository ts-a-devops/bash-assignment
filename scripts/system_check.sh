#!/bin/bash
echo "--- System Report $(date) ---" > logs/system_report.log
df -h >> logs/system_report.log
free -m >> logs/system_report.log
usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')
if [ "$usage" -gt 80 ]; then echo "WARNING: Disk over 80%"; fi
echo "Report saved to logs/system_report.log"
