#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
REPORT_FILE="$LOG_DIR/system_report_$(date '+%Y-%m-%d').log"

mkdir -p "$LOG_DIR"

{
  printf 'System Check Report - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')"
  printf '========================================\n'
  printf '\nDisk Usage (df -h)\n'
  df -h

  printf '\nMemory Usage (free -m)\n'
  free -m

  printf '\nCPU Load (uptime)\n'
  uptime

  printf '\nDisk Usage Warnings (>80%%)\n'
  warnings_found=0
  while read -r filesystem _ _ _ usage mount_point; do
    usage="${usage%\%}"
    if [[ -n "$usage" ]] && (( usage > 80 )); then
      printf 'Warning: %s mounted on %s is at %s%% usage.\n' "$filesystem" "$mount_point" "$usage"
      warnings_found=1
    fi
  done < <(df -P -h | tail -n +2)

  if (( warnings_found == 0 )); then
    printf 'No disk partitions exceed 80%% usage.\n'
  fi

  printf '\nTotal Running Processes\n'
  ps -e --no-headers | wc -l

  printf '\nTop 5 Memory-Consuming Processes\n'
  ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
} | tee "$REPORT_FILE"
