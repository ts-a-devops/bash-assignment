#!/bin/bash

# This script is for System Check Requirements

log_file="system_check_$(date +%Y-%m-%d).log"

# To start the log
{
echo "===== SYSTEM CHECK REPORT ====="
echo "Date: $(date)"
echo ""

# Disk usage
echo ">> Disk Usage:"
df -h
echo ""

# Warning if disk usage exceeds 80%
echo ">> Disk Usage Warnings (Above 80%):"
df -h | awk 'NR>1 {gsub("%","",$5); if($5 > 80) print "WARNING: " $1 " is at " $5 "% usage"}'
echo ""

# Memory usage
echo ">> Memory Usage (MB):"
free -m
echo ""

# CPU load
echo ">> CPU Load:"
uptime
echo ""

# Total running processes
echo ">> Total Running Processes:"
ps -e --no-headers | wc -l
echo ""

# Top 5 memory-consuming processes
echo ">> Top 5 Memory-Consuming Processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo ""

echo "===== END OF REPORT ====="

} > "$log_file"

echo "System check completed. Report saved to $log_file"
