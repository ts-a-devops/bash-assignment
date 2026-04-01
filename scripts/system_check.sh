#!/bin/bash

date=$(date +%Y-%m-%d)
logfile=~/bash-assignment/logs/system_report_$date.log


echo "=== Disk Usage ==="
df -h

echo ""
echo "=== Disk Usage Warning Check ==="
df -h | awk 'NR>1 {gsub("%","",$5); if($5+0 > 80) print "WARNING: "$1" is at "$5"% usage!"}'

echo ""
echo "=== Memory Usage ==="
free -m

echo ""
echo "=== CPU Load ==="
uptime

echo ""
echo "=== Running Processes ==="
echo "Total running processes: $(ps aux | wc -l)"

echo ""
echo "=== Top 5 Memory-Consuming Processes ==="
ps aux --sort=-%mem | head -6

{
echo "=== System Report - $date ==="
df -h
free -m
uptime
ps aux --sort=-%mem | head -6
} > "$logfile"

echo ""
echo "Report saved to logs/system_report_$date.log"

