#!/bin/bash

# Adding Colors to give easier identification and structure
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "         SYSTEM HEALTH CHECK"
echo "========================================="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "========================================="

# Process Information
echo -e "\n${YELLOW}[PROCESS INFORMATION]${NC}"
total_processes=$(ps aux --no-headers | wc -l)
echo -e "Total Running Processes: ${GREEN}${total_processes}${NC}"

# Top 5 Memory-Consuming Processes
echo -e "\n${YELLOW}[TOP 5 MEMORY-CONSUMING PROCESSES]${NC}"
echo -e "${BLUE}USER       PID    %MEM     RSS(MB)  COMMAND${NC}"
echo -e "${BLUE}------------------------------------------------${NC}"
ps aux --sort=-%mem | head -6 | tail -5 | awk '{
    rss_mb = $6 / 1024
    printf "%-10s %-6s %-6s %-9s %s\n", $1, $2, $4"%", rss_mb"MB", substr($0, index($0,$11))
}' | while read line; do
    if [[ $line =~ [0-9]+\.?[0-9]*% ]]; then
        mem_percent=$(echo $line | grep -oP '[0-9.]+%' | sed 's/%//')
        if (( $(echo "$mem_percent > 20" | bc -l) )); then
            echo -e "${RED}$line${NC}"
        elif (( $(echo "$mem_percent > 10" | bc -l) )); then
            echo -e "${YELLOW}$line${NC}"
        else
            echo -e "$line"
        fi
    else
        echo "$line"
    fi
done

# Disk Usage Check
echo -e "\n${YELLOW}[DISK USAGE]${NC}"
df -h | grep -E '^/dev/' | while read line; do
    usage=$(echo $line | awk '{print $5}' | sed 's/%//')
    mount=$(echo $line | awk '{print $6}')
    
    if [ $usage -ge 80 ]; then
        echo -e "${RED}⚠ WARNING: $mount is at ${usage}% usage!${NC}"
        echo "  $line"
    else
        echo "  $line"
    fi
done

# Memory Usage Check
echo -e "\n${YELLOW}[MEMORY USAGE]${NC}"
free -h
echo ""
mem_percent=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ $mem_percent -gt 90 ]; then
    echo -e "${RED}⚠ WARNING: Memory usage is at ${mem_percent}%!${NC}"
elif [ $mem_percent -gt 80 ]; then
    echo -e "${YELLOW}⚠ Memory usage is at ${mem_percent}%${NC}"
fi

# CPU Load Check
echo -e "\n${YELLOW}[CPU LOAD]${NC}"
uptime
echo ""
cpu_cores=$(nproc)
load_avg=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
if (( $(echo "$load_avg > $cpu_cores" | bc -l) )); then
    echo -e "${RED}⚠ WARNING: CPU load ($load_avg) exceeds cores ($cpu_cores)!${NC}"
fi

echo -e "\n========================================="
echo "            CHECK COMPLETE"
echo "========================================="

#Log results to system_report.log
CURRENT_DATE=$(date +%F)
LOG_FILE="logs/system_report_${CURRENT_DATE}.log"

{
    echo "------------------------------------------"
    echo "System Report - $(date)"
    echo "------------------------------------------"

    echo "--- Disk Usage ---"
    df -h

    echo -e "\n--- Memory Usage ---"
    free -m

    echo -e "\n--- CPU Load ---"
    uptime

    echo -e "\n--- Top 5 Memory Consuming Processes ---"
    ps aux --sort=-%mem | head -n 6
    
} | tee -a "$LOG_FILE"