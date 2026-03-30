#!/bin/bash
# #!/bin/bash → tells the OS to run this file using bash

set -euo pipefail
# -e: exit on error | -u: error on unset variables | -o pipefail: catch pipe errors

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"
# Variables: no spaces around =. Defined at top for easy changes.

mkdir -p "$LOG_DIR"
# -p: create directory and any missing parents, no error if it exists

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}
# Function: reusable block. $1 = first argument passed to it.
# tee -a: print to screen AND append to log file simultaneously

read -rp "Enter your name: " name
read -rp "Enter your age: " age
read -rp "Enter your country: " country
# read -r: raw input (backslashes treated literally) | -p: show prompt

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  echo "Error: All fields are required."
  exit 1
fi
# [[ ]]: modern bash condition block
# -z: true if string is EMPTY | ||: OR operator | exit 1: stop with error code

if [[ ! "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a number."
  exit 1
fi
# =~: regex match | ^[0-9]+$: only digits, nothing else | !: negation

if   [[ "$age" -lt 18 ]]; then category="Minor"
elif [[ "$age" -le 65 ]]; then category="Adult"
else                            category="Senior"
fi
# -lt: less than | -le: less than or equal | fi: ends the if block

message="Hello, $name! You are $age years old ($category) from $country."
log "$message"
