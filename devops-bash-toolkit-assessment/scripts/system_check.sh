#!/bin/bash

# 1. Setup Environment
# Dynamic log name using current date (e.g., system_report_2024-05-22.log)
DATE=$(date '+%Y-%m-%d')
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

# Ensure log directory exists
if [ ! -d "$LOG_DIR" ]; then
    mkdir "$LOG_DIR"
fi

# Function to write to both Terminal and Log file
log_output() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log_output "========== SYSTEM CHECK REPORT ($DATE) =========="

# 2. CPU Load & Uptime
log_output "\n[1] CPU Load & Uptime:"
log_output "$(uptime)"

# 3. Memory Usage (free -m)
log_output "\n[2] Memory Usage (MB):"
log_output "$(free -m)"

# 4. Disk Usage (df -h)
log_output "\n[3] Disk Usage:"
DISK_INFO=$(df -h | grep '^/dev/')
log_output "$DISK_INFO"

# Check if any disk partition exceeds 80%
# We look for the percentage column and strip the '%' sign to compare
while read -r line; do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    PARTITION=$(echo "$line" | awk '{print $6}')
    
    if [ "$USAGE" -gt 80 ]; then
        log_output "!!! WARNING: Partition $PARTITION is at ${USAGE}% usage !!!"
    fi
done <<< "$DISK_INFO"

# 5. Process Information
log_output "\n[4] Total Running Processes:"
log_output "$(ps aux | wc -l)"

log_output "\n[5] Top 5 Memory-Consuming Processes:"
# Sorts by the 4th column (%MEM) in reverse order
log_output "$(ps aux --sort=-%mem | awk 'NR<=6 {print $1, $2, $4, $11}')"

log_output "\n================ END OF REPORT ================"
log_output "Report saved to: $LOG_FILE"


