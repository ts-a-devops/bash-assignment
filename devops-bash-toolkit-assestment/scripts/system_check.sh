#!/bin/bash

THRESHOLD=80

df -h
free -m
vmstat 1 10

USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

cd logs/
touch system_report.log


if [[ "$USAGE" -gt "$THRESHOLD" ]]; then
    echo "WARNING: Disk Usage is at ${USAGE}% which exceeds 80%" >> system_report.log
else
    echo "Disk usage is below 80%" >> system_report.log
fi

ps aux | wc -l
ps aux --sort -%mem | head -5
