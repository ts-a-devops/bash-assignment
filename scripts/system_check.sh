#!/bin/bash

# Configuration
LOG_DIR="logs"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="$LOG_DIR/system_report_$TIMESTAMP.log"
THRESHOLD=80

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Function to write to both console and log file
log_output() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

{
    log_output "=== System Report: $(date) ==="
    
    # 1. Disk Usage (df -h)
    log_output "\n---[Disk Usage]---"
    df -h | tee -a "$LOG_FILE"
    
    # 2. Warn if disk usage exceeds 80% (Checking Root Partition)
    # Picks the usage % for '/', removes the '%' sign for numeric comparison
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
        log_output "\n*** WARNING: Disk usage is at ${DISK_USAGE}% (Exceeds ${THRESHOLD}%) ***"
    fi

    # 3. Memory Usage (free -m)
    log_output "\n---[Memory Usage (MB)]---"
    free -m | tee -a "$LOG_FILE"

    # 4. CPU Load (uptime)
    log_output "\n---[CPU Load]---"
    uptime | tee -a "$LOG_FILE"

    # 5. Count Total Running Processes
    # Subtract 1 to account for the 'ps' header
    TOTAL_PROC=$(ps aux | wc -l)
    log_output "\n---[Total Running Processes]---: $((TOTAL_PROC - 1))"
    
    # 6. Top 5 Memory-Consuming Processes
    log_output "\n---[Top 5 Memory-Consuming Processes]---"
    ps aux --sort=-%mem | awk 'NR<=6 {print $0}' | tee -a "$LOG_FILE"
    

}

echo -e "\nReport saved to: $LOG_FILE"

