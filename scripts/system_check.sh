#!/usr/bin/env bash

mkdir -p logs
DATE_STAMP="$(date '+%F_%H-%M-%S')"
LOG_FILE="logs/system_report_${DATE_STAMP}.log"

{
  echo "System Check Report - $(date)"
  echo "================================"
  echo
  echo "Disk Usage:"
  df -h
  echo
  echo "Memory Usage:"
  free -m
  echo
  echo "CPU Load:"
  uptime
  echo
  echo "Total Running Processes:"
  ps -eo pid= | wc -l
  echo
  echo "Top 5 Memory-Consuming Processes:"
  ps aux --sort=-%mem | head -n 6
  echo
  echo "Disk Usage Warnings (>80%):"
  df -hP | awk 'NR>1 {gsub("%","",$5); if ($5 > 80) print "WARNING: " $6 " is at " $5 "%"}'
} | tee "$LOG_FILE"
