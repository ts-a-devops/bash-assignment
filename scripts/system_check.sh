#!/bin/bash

LOG_FILE="../logs/system_report_$(date +%Y).log"

{
  echo "===== SYSTEM REPORT ====="
  
  echo "---------- Disk Usage ----------"
  df -h
  
  echo "---------- Memory Usage ----------"
  free -m
  
  echo "---------- CPU Load ----------"
  uptime

  # Disk warning (Concise one-liner)
  [[ $(df / --output=pcent | tail -1 | tr -dc '0-9') -gt 80 ]] && echo "WARNING: Disk usage is above 80%"

  echo "----- Total running processes: $(ps -ef | wc -l)"

  echo "---------- Top 5 memory-consuming processes ----------"
  ps aux --sort=-%mem | head -6

} | tee -a "$LOG_FILE"