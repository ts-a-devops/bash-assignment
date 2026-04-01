#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
REPORT_FILE="$LOG_DIR/system_report_$(date '+%Y%m%d_%H%M%S').log"

mkdir -p "$LOG_DIR"

{
  echo "System Report - $(date)"
  echo "========================================"
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

  echo "Disk Usage Warnings (>80%):"
  warnings="$(df -P | awk 'NR>1 {gsub(/%/, "", $5); if ($5 > 80) printf "WARNING: %s is %s%% full (mounted on %s)\n", $1, $5, $6}')"
  if [[ -n "$warnings" ]]; then
    echo "$warnings"
  else
    echo "No disk partitions above 80%."
  fi
  echo

  echo "Total Running Processes:"
  ps -e --no-headers | wc -l
  echo

  echo "Top 5 Memory-Consuming Processes:"
  ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
  echo "========================================"
} | tee "$REPORT_FILE"

echo "Report saved to: $REPORT_FILE"
