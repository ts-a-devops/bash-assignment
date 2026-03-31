#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
REPORT="$LOG_DIR/system_report_$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$LOG_DIR"
DISK_WARN_THRESHOLD=80
section() { echo ""; echo "===== $* ====="; }

{
    echo "System Health Report - $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Hostname: $(hostname)"

    section "DISK USAGE"
    df -h
    while IFS= read -r line; do
        usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
        mount=$(echo "$line" | awk '{print $6}')
        if [[ "$usage" =~ ^[0-9]+$ ]] && (( usage > DISK_WARN_THRESHOLD )); then
            echo "WARNING: '$mount' is at ${usage}% - exceeds threshold!"
        fi
    done < <(df -h | tail -n +2)

    section "MEMORY USAGE"
    echo "Memory details via systeminfo:"
    systeminfo 2>/dev/null | grep -E "Total Physical Memory|Available Physical Memory" || echo "Memory info unavailable"

    section "CPU LOAD"
    wmic cpu get loadpercentage 2>/dev/null | grep -v "^$" || echo "CPU load: N/A"

    section "TOTAL RUNNING PROCESSES"
   proc_count=$(tasklist 2>/dev/null | tail -n +4 | wc -l)
echo "Total processes: $proc_count"

    section "TOP 5 MEMORY-CONSUMING PROCESSES"
    printf "%-8s %-6s %-6s %s\n" "PID" "%CPU" "%MEM" "COMMAND"
    tasklist 2>/dev/null | sort -rk5 | head -8 | tail -5

} | tee "$REPORT"

echo ""
echo "Report saved to: $REPORT"