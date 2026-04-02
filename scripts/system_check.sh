#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
REPORT="logs/system_report_$(date '+%F_%H-%M-%S').log"

{
  echo "===== SYSTEM CHECK REPORT ====="
  echo "Date: $(date)"
  echo

  echo "---- Disk Usage ----"
  df -h
  echo

  echo "---- Memory Usage ----"
  free -m
  echo

  echo "---- CPU Load ----"
  uptime
  echo

  echo "---- Disk Warning (>80%) ----"
  df -h | awk 'NR>1 {gsub("%","",$5); if ($5 > 80) print "WARNING: " $6 " is at " $5 "%"}'
  echo

  echo "---- Total Processes ----"
  ps -e --no-headers | wc -l
  echo

  echo "---- Top 5 Memory Processes ----"
  ps -eo pid,comm,%mem --sort=-%mem | head -n 6
  echo

} | tee "$REPORT"
