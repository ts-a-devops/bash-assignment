#!/bin/bash

LOG_DIR="../logs"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

mkdir -p "$LOG_DIR"

echo "===== SYSTEM REPORT =====" | tee "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

## Disk usage
echo "---- Disk Usage ----" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

## Check disk warning
echo "" | tee -a "$LOG_FILE"
echo "---- Disk Warning ----" | tee -a "$LOG_FILE"

df -h | awk 'NR>1 {print $5 " " $1}' | while read usage partition; do
    percent=$(echo $usage | tr -d '%')
        if [ "$percent" -gt 80 ]; then
                echo "WARNING: $partition is above 80% usage ($usage)" | tee -a "$LOG_FILE"
                    fi
                    done

                    # Memory usage
                    echo "" | tee -a "$LOG_FILE"
                    echo "---- Memory Usage ----" | tee -a "$LOG_FILE"
                    free -m | tee -a "$LOG_FILE"

                    # CPU load
                    echo "" | tee -a "$LOG_FILE"
                    echo "---- CPU Load ----" | tee -a "$LOG_FILE"
                    uptime | tee -a "$LOG_FILE"

                    # Process count
                    echo "" | tee -a "$LOG_FILE"
                    echo "---- Running Processes ----" | tee -a "$LOG_FILE"
                    ps aux | wc -l | tee -a "$LOG_FILE"

                    # Top 5 memory-consuming processes
                    echo "" | tee -a "$LOG_FILE"
                    echo "---- Top 5 Memory Consuming Processes ----" | tee -a "$LOG_FILE"
                    ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

                    echo "" | tee -a "$LOG_FILE"
                    echo "Report saved to $LOG_FILE"

