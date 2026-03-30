
#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="../logs/system_report_$DATE.log"

echo "=== SYSTEM REPORT ($DATE) ===" | tee -a "$LOG_FILE"

# Disk usage
echo -e "\n--- Disk Usage ---" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Warn if disk usage exceeds 80%
echo -e "\n--- Disk Warning (>80%) ---" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {print $5 " " $1}' | while read output;
do
    usage=$(echo $output) | awk '{print $1}' | sed 's/%//g'
    partition=$(echo $output) | awk '{print $2}'

    if [[ "$usage" -gt 80 ]]; then
        echo "WARNING: $partition is at ${usage}% usage" | tee -a "$LOG_FILE"
    fi
done

# Memory Usage
echo -e "\n--- Memory Usage ---" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
echo -e "\n--- CPU LOAD ---" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Total Running process
echo -e "\n--- Total Running Process ---" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

# Top five memory consuming processes
echo -e "\n--- Top five memory consuming processes ---" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo -e "\n==== END OF REPORT ====" | tee -a "$LOG_FILE"
