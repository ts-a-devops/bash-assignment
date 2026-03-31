#!/bin/bash
set -euo pipefail
mkdir -p logs

DATE=$(date '+%Y-%m-%d')
LOG_FILE="logs/system_report_${DATE}.log"


echo "=== SYSTEM HEALTH CHECK ==="
echo "DATE: $(date)"
echo


#Checking for disk usage

echo "Disk Usage:"
df -h
echo

echo "Disk Usage Warnings (>80%):"
df -h | awk 'NR>1 {gsub("%",""); if ($5 > 80) print "WARNING: " $0}'
echo

#Checking for Memory usage(macOS)

echo "Memory Usage:"
vm_stat
echo

#CPU load check

echo "CPU Load:"
uptime
echo

#Running Processes
echo "Total Running Processes:"
ps aux | wc -l

#Top 5 memory usage
echo "Top 5 Memory-Consuming Processes"
ps aux | sort -nrk 4 | head -n 6


echo "=== END OF REPORT ==="
