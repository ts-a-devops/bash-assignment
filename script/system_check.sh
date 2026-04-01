#!/bin/bash

# 1. Setup Variables
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

# Function to log and print simultaneously
log_info() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

echo "--- Starting System Check: $(date) ---" > "$LOG_FILE"

# 2. Disk Usage & Warning
log_info "\n### Disk Usage ###"
df -h | tee -a "$LOG_FILE"

# Logic for 80% Warning
# We extract the percentage of the root filesystem (/)
disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$disk_usage" -gt 80 ]; then
    log_info "\n*** WARNING: Disk usage is above 80% ($disk_usage%) ***"
fi

# 3. Memory Usage
log_info "\n### Memory Usage (MB) ###"
free -m | tee -a "$LOG_FILE"

# 4. CPU Load
log_info "\n### CPU Load & Uptime ###"
uptime | tee -a "$LOG_FILE"

# 5. Process Stats
log_info "\n### Process Statistics ###"
total_proc=$(ps aux | wc -l)
log_info "Total Running Processes: $total_proc"

log_info "\n### Top 5 Memory-Consuming Processes ###"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo -e "\nReport saved to: $LOG_FILE"
