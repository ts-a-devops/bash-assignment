#!/bin/bash

# =========================================================
# SYSTEM HEALTH REPORT SCRIPT
# Generates a daily system report (disk, memory, CPU, processes)
# and writes output to a timestamped log file.
# =========================================================


# ---------------- SETUP LOG DIRECTORY & LOG FILE ----------------

# Ensure logs directory exists
mkdir -p logs

# Generate date (YYYY-MM-DD format)
DATE=$(date +%F)

# Define log file path
log_file="logs/system_report_${DATE}.log"

# Ensure log file exists (not strictly required, tee will create it)
touch "$log_file"


# ---------------- REPORT HEADER ----------------

echo "================ SYSTEM REPORT ================" | tee "$log_file"
echo "Generated On: $(date)" | tee -a "$log_file"
echo "" | tee -a "$log_file"


# ---------------- DISK USAGE ----------------

echo ">>> Disk Usage:" | tee -a "$log_file"
df -h | tee -a "$log_file"

echo "" | tee -a "$log_file"

# Disk usage warning (>80%)
echo ">>> Disk Usage Warnings (>80%):" | tee -a "$log_file"
df -h | awk 'NR>1 {
  gsub("%","",$5);
  if ($5 > 80)
    print "WARNING: " $1 " is at " $5 "% usage"
}' | tee -a "$log_file"

echo "" | tee -a "$log_file"


# ---------------- MEMORY USAGE ----------------

echo ">>> Memory Usage:" | tee -a "$log_file"
free -m | tee -a "$log_file"

echo "" | tee -a "$log_file"


# ---------------- CPU LOAD ----------------

echo ">>> CPU Load Average (uptime):" | tee -a "$log_file"
uptime | tee -a "$log_file"

echo "" | tee -a "$log_file"


# ---------------- PROCESS COUNT ----------------

echo ">>> Total Running Processes:" | tee -a "$log_file"
ps -e --no-headers | wc -l | tee -a "$log_file"

echo "" | tee -a "$log_file"


# ---------------- TOP MEMORY CONSUMERS ----------------

echo ">>> Top 5 Memory Consuming Processes:" | tee -a "$log_file"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tee -a "$log_file"

echo "" | tee -a "$log_file"


# ---------------- END OF REPORT ----------------

echo "================ END OF REPORT ================" | tee -a "$log_file"
