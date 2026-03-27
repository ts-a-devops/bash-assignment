#!/bin/bash

DATE=$(date +%Y-%m-%d)
LOG_FILE="/logs/system_report_${DATE}.log"


df -h | grep '^/dev/' | while read line; do
    # Extract usage percentage (remove % sign)
    USAGE=$(echo $line | awk '{print $5}' | sed 's/%//')
    MOUNT=$(echo $line | awk '{print $6}')
    
    # Check if usage exceeds 80%
    if [ $USAGE -gt 80 ]; then
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$TIMESTAMP] WARNING: Disk usage on $MOUNT is at ${USAGE}%" >> "$LOG_FILE"
        echo "[$TIMESTAMP] Details: $line" >> "$LOG_FILE"
    fi
done

#set -x
#Print Disk Usage
echo "=========Disk Usage========="
df -h | grep '^/dev/'
echo "=========Disk Usage========="

echo

#Print Memory Usage
echo "=========Memory Usage======="
free -m
echo "=========Memory Usage======="

echo

#Print Uptime
echo "=========Uptime============="
uptime
echo "=========Uptime============="

echo 

echo "TOTAL RUNNING PROCESSES:"
echo "---------------------------"
# Count all processes (excluding threads)
TOTAL_PROCS=$(ps -e --no-headers | wc -l)
echo "Total processes: $TOTAL_PROCS"

# Count processes by state
echo "Process states:"
ps -e -o stat --no-headers | cut -c1 | sort | uniq -c | while read count state; do
    case $state in
        R) echo "  Running (R): $count" ;;
        S) echo "  Sleeping (S): $count" ;;
        D) echo "  Uninterruptible sleep (D): $count" ;;
        Z) echo "  Zombie (Z): $count" ;;
        T) echo "  Stopped (T): $count" ;;
        *) echo "  Other ($state): $count" ;;
    esac
done

echo

# 2. Display top 5 memory-consuming processes
echo "TOP 5 MEMORY-CONSUMING PROCESSES:"
echo "-----------------------------------"
printf "%-8s %-10s %-10s %-15s %s\n" "PID" "USER" "%MEM" "RSS (MB)" "COMMAND"
echo "--------------------------------------------------------------"
ps aux --sort=-%mem | head -6 | tail -5 | while read line; do
    PID=$(echo $line | awk '{print $2}')
    USER=$(echo $line | awk '{print $1}')
    MEM=$(echo $line | awk '{print $4}')
    RSS=$(echo $line | awk '{print $6}')
    RSS_MB=$((RSS / 1024))
    CMD=$(echo $line | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}' | cut -c1-50)

    printf "%-8s %-10s %-10s %-15s %s\n" "$PID" "$USER" "$MEM%" "$RSS_MB" "$CMD"
done

