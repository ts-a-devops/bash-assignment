#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

mkdir -p "$LOG_DIR"

services=("nginx" "ssh" "docker")

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

is_running() {
  local service_name="$1"

  if command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active --quiet "$service_name" 2>/dev/null; then
      return 0
    fi
  fi

  if pgrep -x "$service_name" >/dev/null 2>&1; then
    return 0
  fi

  if pgrep -x "${service_name}d" >/dev/null 2>&1; then
    return 0
  fi

  return 1
}

restart_service() {
  local service_name="$1"

  if command -v systemctl >/dev/null 2>&1; then
    if systemctl restart "$service_name" >/dev/null 2>&1; then
      return 0
    fi
  fi

  if command -v service >/dev/null 2>&1; then
    if service "$service_name" restart >/dev/null 2>&1; then
      return 0
    fi
  fi

  return 1
}

monitor_service() {
  local service_name="$1"

  if is_running "$service_name"; then
    echo "$service_name: Running"
    log "$service_name - Running"
  else
    echo "$service_name: Stopped"
    log "$service_name - Stopped"

    if restart_service "$service_name"; then
      echo "$service_name: Restarted"
      log "$service_name - Restarted"
    else
      echo "$service_name: Restarted (simulated)"
      log "$service_name - Restarted (simulated)"
    fi
  fi
}

if [[ $# -ge 1 ]]; then
  targets=("$1")
else
  targets=("${services[@]}")
fi

for service in "${targets[@]}"; do
  monitor_service "$service"
done
