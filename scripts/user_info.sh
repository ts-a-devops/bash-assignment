#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/user_info.log"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Collect name
while true; do
    read -rp "Enter your name: " NAME
    [[ -n "${NAME// }" ]] && break
    echo "Name cannot be empty. Try again."
done

# Collect and validate age
while true; do
    read -rp "Enter your age: " AGE
    if [[ -z "$AGE" ]]; then
        echo "Age cannot be empty. Try again."
    elif ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
        echo "Age must be a number. Got: '$AGE'"
    elif (( AGE > 130 )); then
        echo "Please enter a realistic age."
    else
        break
    fi
done

# Collect country
while true; do
    read -rp "Enter your country: " COUNTRY
    [[ -n "${COUNTRY// }" ]] && break
    echo "Country cannot be empty. Try again."
done

# Determine age category
if (( AGE < 18 )); then
    CATEGORY="Minor"
elif (( AGE <= 65 )); then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

echo ""
echo "Hello, $NAME! You are from $COUNTRY."
echo "Age: $AGE | Category: $CATEGORY"

log "Name: $NAME | Age: $AGE | Country: $COUNTRY | Category: $CATEGORY"
echo "Output saved to: $LOG_FILE"
