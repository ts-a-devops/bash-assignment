#!/bin/bash
LOG="../logs/system_report_$(date +%F). log"
echo "... System Check $(date) ---" >> "LOG"
# disk check usage
Usage=$(df / | grep/ | awk '{ print $5 }' | sed 's/%//')
if [[ "$usage" -gt 80 ]]; then
    echo "⚠️ WARNING: Disk usage is at $usage%!" | tee -a "$LOG"
fi
# Display Memory and CPU
free -m >> "$LOG"
uptime >> "$LOG"

echo "Report saved to $LOG"
