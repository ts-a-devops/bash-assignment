#!/bin/bash

LOG_DIR="logs"
LOG_FILE="../logs/user_info.log"

mkdir -p "$LOG_DIR"

log() {
  echo "$1" | tee -a "$LOG_FILE"
}

separator() {
  log "-------------------------------------------"
}

# ── Collect Name ──────────────────────────────
read -rp "Enter your name: " NAME
NAME="${NAME//[[:space:]]/}"  # strip all whitespace

if [[ -z "$NAME" ]]; then
  echo "Error: Name cannot be empty." >&2
  exit 1
fi

# ── Collect Age ───────────────────────────────
read -rp "Enter your age: " AGE

if [[ -z "$AGE" ]]; then
  echo "Error: Age cannot be empty." >&2
  exit 1
fi

if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a numeric value. You entered: '$AGE'" >&2
  exit 1
fi

if (( AGE > 150 )); then
  echo "Error: Age '$AGE' is not a realistic value." >&2
  exit 1
fi

# ── Collect Country ───────────────────────────
read -rp "Enter your country: " COUNTRY
COUNTRY="${COUNTRY#"${COUNTRY%%[![:space:]]*}"}"  # trim leading whitespace

if [[ -z "$COUNTRY" ]]; then
  echo "Error: Country cannot be empty." >&2
  exit 1
fi

# ── Determine Age Category ────────────────────
if (( AGE < 18 )); then
  CATEGORY="Minor"
elif (( AGE <= 65 )); then
  CATEGORY="Adult"
else
  CATEGORY="Senior"
fi

# ── Timestamp ─────────────────────────────────
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# ── Output & Log ──────────────────────────────
separator
log "User Info Report — $TIMESTAMP"
separator
log "Hello, $NAME! Welcome from $COUNTRY."
log "Age       : $AGE"
log "Category  : $CATEGORY"
log "Country   : $COUNTRY"
separator
log "Output saved to: $LOG_FILE"
