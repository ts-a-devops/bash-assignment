#!/usr/bin/env bash
# user_info.sh — Collects and validates user information, logs output.

set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/user_info.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# ── Prompt for Name ──────────────────────────────────────────────────────────
read -rp "Enter your name: " name
if [[ -z "${name// /}" ]]; then
    echo "Error: Name cannot be empty." >&2
    log "ERROR: Empty name provided."
    exit 1
fi

# ── Prompt for Age ───────────────────────────────────────────────────────────
read -rp "Enter your age: " age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a positive whole number." >&2
    log "ERROR: Invalid age input: '$age'"
    exit 1
fi
if (( age > 150 )); then
    echo "Error: Age '$age' is not a realistic value." >&2
    log "ERROR: Unrealistic age: $age"
    exit 1
fi

# ── Prompt for Country ───────────────────────────────────────────────────────
read -rp "Enter your country: " country
if [[ -z "${country// /}" ]]; then
    echo "Error: Country cannot be empty." >&2
    log "ERROR: Empty country provided."
    exit 1
fi

# ── Determine Age Category ───────────────────────────────────────────────────
if   (( age < 18 ));  then category="Minor"
elif (( age <= 65 )); then category="Adult"
else                       category="Senior"
fi

# ── Output ───────────────────────────────────────────────────────────────────
greeting="Hello, $name! Welcome from $country. You are $age years old — category: $category."
echo ""
echo "================================================"
echo "  $greeting"
echo "================================================"
echo ""

log "INFO: $greeting"
echo "Output saved to: $LOG_FILE"
