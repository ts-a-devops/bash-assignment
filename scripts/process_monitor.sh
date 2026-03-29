#!/bin/bash

mkdir -p logs
LOG_FILE="logs/process_monitor.log"

echo "Process Monitor Report - $(date)" | tee -a $LOG_FILE
echo "----------------------------------------" | tee -a $LOG_FILE

# Total number of running processes
echo "Total running processes:" | tee -a $LOG_FILE
ps aux --no-heading | wc -l | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# Top CPU-consuming processes
echo "Top 5 CPU-consuming processes:" | tee -a $LOG_FILE
ps aux --sort=-%cpu | head -n 6 | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# Top memory-consuming processes
echo "Top 5 memory-consuming processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# Bonus requirement: process check
services=("nginx" "ssh" "docker")
process=$1

if [[ -n "$process" ]]; then
    if [[ " ${services[@]} " =~ " ${process} " ]]; then
        if pgrep -x "$process" > /dev/null; then
            echo "$process: Running" | tee -a $LOG_FILE
        else
            echo "$process: Stopped" | tee -a $LOG_FILE
            # Simulate restart
            echo "$process: Restarted" | tee -a $LOG_FILE
        fi
    else
        echo "$process is not in monitored services list" | tee -a $LOG_FILE
    fi
fi

echo "Process monitoring completed." | tee -a $LOG_FILE

