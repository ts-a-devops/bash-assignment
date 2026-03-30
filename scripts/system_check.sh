#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="logs"
mkdir -p "$LOG_DIR"
REPORT_FILE="$LOG_DIR/system_report_$(date '+%Y%m%d_%H%M%S').log"

{
  echo "System Check Report"
  echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo

  echo "=== Disk Usage (df -P -h) ==="
  df -P -h
  echo

  echo "=== Memory Usage ==="
  if command -v free >/dev/null 2>&1; then
    free -m
  elif command -v vm_stat >/dev/null 2>&1; then
    page_size="$(vm_stat | awk '/page size of/ {gsub("\\.", "", $8); print $8}')"
    if [[ -z "$page_size" ]]; then
      page_size=4096
    fi

    free_pages="$(vm_stat | awk -F': ' '/Pages free/ {gsub("\\.", "", $2); print $2}')"
    active_pages="$(vm_stat | awk -F': ' '/Pages active/ {gsub("\\.", "", $2); print $2}')"
    inactive_pages="$(vm_stat | awk -F': ' '/Pages inactive/ {gsub("\\.", "", $2); print $2}')"
    speculative_pages="$(vm_stat | awk -F': ' '/Pages speculative/ {gsub("\\.", "", $2); print $2}')"
    wired_pages="$(vm_stat | awk -F': ' '/Pages wired down/ {gsub("\\.", "", $2); print $2}')"

    free_pages="${free_pages:-0}"
    active_pages="${active_pages:-0}"
    inactive_pages="${inactive_pages:-0}"
    speculative_pages="${speculative_pages:-0}"
    wired_pages="${wired_pages:-0}"

    used_pages=$((active_pages + inactive_pages + speculative_pages + wired_pages))
    total_pages=$((used_pages + free_pages))

    used_mb=$((used_pages * page_size / 1024 / 1024))
    free_mb=$((free_pages * page_size / 1024 / 1024))
    total_mb=$((total_pages * page_size / 1024 / 1024))

    printf "total(MB): %s\nused(MB): %s\nfree(MB): %s\n" "$total_mb" "$used_mb" "$free_mb"
    echo
    echo "Raw macOS memory summary:"
    vm_stat | head -n 6
  else
    echo "Memory command not available on this system."
  fi
  echo

  echo "=== CPU Load (uptime) ==="
  if command -v uptime >/dev/null 2>&1; then
    uptime
  elif command -v wmic >/dev/null 2>&1; then
    boot_time="$(wmic os get lastbootuptime | awk 'NR==2 {print $1}')"
    if [[ -n "$boot_time" ]]; then
      echo "Windows last boot time: $boot_time"
    else
      echo "CPU load command not available on this system."
    fi
  else
    echo "CPU load command not available on this system."
  fi
  echo

  echo "=== Disk Usage Warnings (>80%) ==="
  warnings=0
  while read -r mount percent; do
    if [[ "$percent" =~ ^[0-9]+$ ]] && (( percent > 80 )); then
      echo "WARNING: $mount is at ${percent}% usage"
      warnings=$((warnings + 1))
    fi
  done < <(df -P -h | awk 'NR>1 {use=$(NF-1); gsub("%", "", use); print $NF, use}')

  if (( warnings == 0 )); then
    echo "No partitions above 80% usage."
  fi
  echo

  echo "=== Total Running Processes ==="
  if ps -e --no-headers >/dev/null 2>&1; then
    process_count="$(ps -e --no-headers | wc -l | tr -d ' ')"
  elif ps -A >/dev/null 2>&1; then
    process_count="$(ps -A | tail -n +2 | wc -l | tr -d ' ')"
  elif ps -e >/dev/null 2>&1; then
    process_count="$(ps -e | tail -n +2 | wc -l | tr -d ' ')"
  else
    process_count="$(ps | tail -n +2 | wc -l | tr -d ' ')"
  fi
  echo "$process_count"
  echo

  echo "=== Top 5 Memory-Consuming Processes ==="
  if ps -eo pid,comm,%mem,%cpu --sort=-%mem >/dev/null 2>&1; then
    ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
  elif ps aux >/dev/null 2>&1 && ps aux | head -n 1 | grep -q "%MEM"; then
    {
      echo "PID COMMAND %MEM %CPU"
      ps aux | awk 'NR>1 {print $2, $11, $4, $3}' | sort -k3 -nr | head -n 5
    }
  else
    echo "Top memory process list is unavailable on this system."
  fi
} | tee "$REPORT_FILE"

echo "Report saved to $REPORT_FILE"
