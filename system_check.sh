#!/bin/bash

# This script displays the disk usage, memorey usage, CUP load (uptime) and also warn if disk usage exceeds 80%


# Displays the disk usage, memorey usage, CUP load (uptime)

log_dir="logs"
log_file="${log_dir}/system_report_$(date '+%Y-%m-%d').log"

echo "Running system check...."
echo ""

# === DISK USAGE ====
echo "===== DISK USAGE ====" | tee -a "${log_file}"

# display and foward the output of disk usage to the log_file
df -h | tee -a "${log_file}"
echo "" | tee -a "${log_file}"

# ==== MEMORY USAGE ===
echo "==== MEMORY USAGE ====" | tee -a "${log_file}"

# forward the output for memory usage to the log_file
free -m | tee -a "${log_file}"
echo "" | tee -a "${log_file}"

# ==== CPU LOAD ====
echo "=== CPU LOAD ====" | tee -a "${log_file}"

# forward the output for the CPU load (uptime) to the log_file
uptime | tee -a "${log_file}"
echo "" | tee -a "${log_file}"


# ==== DISK WARNING CHECK ====
echo "==== DISK WARNING CHECK ====" | tee -a "${log_file}"

df -h | tail -n +2 | while read line;
do
    usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
    partition=$(echo "$line" | awk '{print $6}')

    #check if usage is a number and above 80
    if [[ "${usage}" =~ ^[0-9]+$ ]] && [ "${usage}" -gt 80 ]; then
        echo "WARNING: $partition is at ${usage}% - above 80%!" | tee -a "${log_file}"
    fi
done

# === TOTAL RUNNING PROCESSES ====
echo "=== TOTAL RUNNING PROCESSES" | tee -a "${log_file}"

# Count all running processes (subtract 1 to exclude the header line)
total=$(ps aux | wc -l)
total=$((total - 1))

echo "Total running processes: ${total}" | tee -a "${log_file}"
echo "" | tee -a "${log_file}"

# ==== TOP 5 MEMORY-CONSUMING PROCESSES ====
echo "==== TOP 5 MEMORY-CONSUMING PROCESSES ====" | tee -a "${log_file}"

# Sort processes by memory usage, show only the top 5
# ps aux gives all processes, --sort=-%mem sorts by memory (highest first)
ps aux --sort=-%mem | head -6 | tee -a "${log_file}"
echo "" | tee -a "${log_file}"

# ====  DONE =====
echo "========================================"  | tee -a "${log_file}"
echo "Report saved to: ${log_file}"
echo "========================================"  | tee -a "${log_file}"
