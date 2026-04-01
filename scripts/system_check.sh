#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_DIR="${PROJECT_ROOT}/logs"
REPORT_FILE="${LOG_DIR}/system_report_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "${LOG_DIR}"

{
  echo "System Check Report - $(date)"
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
  echo "Running Process Count:"
  ps -e --no-headers | wc -l
  echo
  echo "Top 5 Memory-Consuming Processes:"
  ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
  echo
  echo "Disk Usage Warnings:"
} | tee "${REPORT_FILE}"

while IFS= read -r line; do
  usage="$(awk '{print $5}' <<< "${line}" | tr -d '%')"
  mount_point="$(awk '{print $6}' <<< "${line}")"

  if [[ "${usage}" =~ ^[0-9]+$ ]] && (( usage > 80 )); then
    echo "WARNING: Disk usage on ${mount_point} is at ${usage}%." | tee -a "${REPORT_FILE}"
  fi
done < <(df -hP | tail -n +2)
