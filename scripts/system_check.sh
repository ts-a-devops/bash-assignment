#!/bin/bash
# --------------------------------------------------------------------------
# Script: system_check.sh
# Description: Checks the current disk space, memory, and CPU load. 
#              Issues a warning if disk space is low (over 80%).
#              Generates a timestamped report file in logs/.
# --------------------------------------------------------------------------

# Set up the location for our logs
LOG_DIR="logs"
mkdir -p "$LOG_DIR"

# Generate a log file name based on the current date (e.g., YYYY-MM-DD)
CURRENT_DATE=$(date "+%Y-%m-%d")
LOG_FILE="$LOG_DIR/system_report_${CURRENT_DATE}.log"

echo "=== System Metrics Check ==="

# We will redirect our information to the log file.
# Rather than appending `>>` to every line, we wrap the commands in a function
# to capture the output all at once!

generate_report() {
    echo "==========================================="
    echo "        SYSTEM METRICS OVERVIEW            "
    echo "==========================================="
    echo "Report Date: $(date)"
    
    # 1. Disk Usage
    # The 'df -h' command gets "h"uman readable disk stats out.
    echo ""
    echo "--- Disk Usage ---"
    df -h
    
    # Let's check if the root mount ( / ) is greater than 80% usage
    # We utilize 'awk' to easily isolate the 'Use%' column.
    # We remove the '%' sign utilizing 'sed'.
    root_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ ! -z "$root_usage" ] && [ "$root_usage" -gt 80 ]; then
        echo ""
        echo "🚨 WARNING: Root disk space exceeds 80%! (Currently: ${root_usage}%)"
    fi
    
    # 2. Memory Usage
    # The 'free -m' command dumps memory in MB (-m param).
    echo ""
    echo "--- Memory Usage ---"
    free -m
    
    # 3. CPU Load
    # The 'uptime' command showcases simple system CPU load averages.
    echo ""
    echo "--- CPU Load ---"
    uptime
    
    # 4. Total Running Processes
    # 'ps -e' gets a list of processes; 'wc -l' (word count lines) counts them.
    echo ""
    echo "--- Running Processes ---"
    process_count=$(ps -e | wc -l)
    echo "Total processes currently running: $process_count"
    
    # 5. Top 5 Memory-Consuming Processes
    # We pipe 'ps aux' into bash 'head' to trim it to the top 6 lines (1 header + 5 processes)
    echo ""
    echo "--- Top 5 Memory Consumers ---"
    ps aux --sort=-%mem | head -n 6
    
    echo ""
    echo "==========================================="
}

# The pipe here with the 'tee' tool catches the function's output and 
# both prints it to the console and appends it to out $LOG_FILE.
generate_report | tee -a "$LOG_FILE"

echo "Report successfully saved to $LOG_FILE"
