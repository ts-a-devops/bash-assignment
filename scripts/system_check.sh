#!/bin/bash
set -euo pipefail
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="$LOG_DIR/system_report_$DATE.log"
log() {
echo "$(date '+%Y-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}
echo "Disk Usage"
df -h | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {print $5 " " $1}' | while read output; do
usage=$(echo $output | awk '{print $1}' | tr -d '%')
partition=$(echo $output |awk '{print $2}')
if [ "$usage" -ge 80 ];then
echo "WARNING: $partition is at ${usage}% usage"
log "WARNING: $partition is at ${usage}% usage"
fi
done
echo "Memory Usage"
free -m | tee -a "$LOG_FILE"
echo "CPU Load:"
uptime | tee -a "$LOG_FILE"
process_count=$(ps aux | wc -1)
echo "Total Processes: $process_count" | tee -a "LOG_FILE"
echo "Top 5 Memory Consuming Processes:"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
