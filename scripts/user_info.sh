#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_DIR/user_info.log"
}

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: age must be numeric."
    log "ERROR - Invalid age entered: '$age'"
    exit 1
fi

if (( age < 18 )); then
    category="Minor"
elif (( age < 65 )); then
    category="Adult"
else
    category="Senior"
fi

message="Hello, $name from $country! You are $age years old. Age category: $category"
echo "$message"
log "SUCCESS - $message"
