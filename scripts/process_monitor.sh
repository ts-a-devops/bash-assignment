#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_DIR="${PROJECT_ROOT}/logs"
LOG_FILE="${LOG_DIR}/process_monitor.log"

mkdir -p "${LOG_DIR}"

services=("nginx" "ssh" "docker")

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "${LOG_FILE}"
}

process_name="${1:-}"

if [[ -z "${process_name}" ]]; then
  echo "Usage: ./process_monitor.sh <process_name>"
  echo "Known services: ${services[*]}"
  exit 1
fi

if pgrep -x "${process_name}" >/dev/null 2>&1; then
  message="${process_name}: Running"
  echo "${message}"
  log_message "${message}"
  exit 0
fi

if [[ " ${services[*]} " == *" ${process_name} "* ]]; then
  if systemctl list-unit-files | grep -q "^${process_name}\.service"; then
    if systemctl restart "${process_name}" 2>/dev/null; then
      message="${process_name}: Restarted"
    else
      message="${process_name}: Stopped (restart attempt failed)"
    fi
  else
    message="${process_name}: Stopped (restart simulated)"
  fi
else
  message="${process_name}: Stopped"
fi

echo "${message}"
log_message "${message}"
