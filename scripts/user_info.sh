#!/bin/bash
# user_info.sh - Collects and validates user information
# Written by Dave Woks

set -uo pipefail

LOGFILE=~/bash-assignment/logs/user_info.log
mkdir -p ~/bash-assignment/logs

log_action() {
    echo "[$(date +%F\ %T)] $1" >> "$LOGFILE"
}

read -p "Enter your name: " NAME
if [[ -z "$NAME" ]]; then
    echo "Error: Name cannot be empty."
    log_action "ERROR: Empty name provided."
    exit 1
fi

read -p "Enter your age: " AGE
if [[ ! "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
    log_action "ERROR: Invalid age: $AGE"
    exit 1
fi

read -p "Enter your country: " COUNTRY
if [[ -z "$COUNTRY" ]]; then
    echo "Error: Country cannot be empty."
    log_action "ERROR: Empty country provided."
    exit 1
fi

if [[ $AGE -lt 18 ]]; then
    CATEGORY="Minor"
elif [[ $AGE -le 65 ]]; then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

echo ""
echo "Hello, $NAME!"
echo "Age: $AGE ($CATEGORY)"
echo "Country: $COUNTRY"

log_action "User: $NAME | Age: $AGE ($CATEGORY) | Country: $COUNTRY"
