#!/usr/bin/env bash
set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

# Generate timestamp for log file
timestamp=$(date +"%Y%m%d_%H%M%S")
logfile="logs/system_report_${timestamp}.log"

# Function to log to both terminal and file
log() {
    echo "$1" | tee -a "$logfile"
}

# Start report
log "=========================================="
log "System Report - $(date '+%Y-%m-%d %H:%M:%S')"
log "=========================================="

# 1. Disk usage
log "\n--- DISK USAGE ---"
df -h | tee -a "$logfile"

# Check disk usage warning (80% threshold)
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [[ -n "$disk_usage" ]] && (( disk_usage > 80 )); then
    log "\n⚠️  WARNING: Disk usage is at ${disk_usage}% (exceeds 80%)"
fi

# 2. Memory usage
log "\n--- MEMORY USAGE ---"
free -m | tee -a "$logfile"

# 3. CPU load
log "\n--- CPU LOAD ---"
uptime | tee -a "$logfile"

# 4. Count total running processes
log "\n--- PROCESS COUNT ---"
process_count=$(ps aux --no-headers | wc -l)
log "Total running processes: $process_count"

# 5. Top 5 memory-consuming processes
log "\n--- TOP 5 MEMORY-CONSUMING PROCESSES ---"
ps aux --sort=-%mem | head -6 | tee -a "$logfile"

log "\n=========================================="
log "Report saved to: $logfile"
log "=========================================="


