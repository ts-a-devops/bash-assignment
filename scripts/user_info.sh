#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/user_info.log"
mkdir -p "${LOG_DIR}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

# Prompt for input
read -r -p "Enter your name: " name
read -r -p "Enter your age: " age
read -r -p "Enter your country: " country

# Validate inputs
if [[ -z "${name}" || -z "${age}" || -z "${country}" ]]; then
    log "ERROR: Missing required input (name, age, or country)"
    echo "Error: All fields are required."
    exit 1
fi

# Validate age is numeric
if ! [[ "${age}" =~ ^[0-9]+$ ]]; then
    log "ERROR: Age must be a numeric value. Received: ${age}"
    echo "Error: Age must be a number."
    exit 1
fi

# Determine age category
if [[ "${age}" -lt 18 ]]; then
    category="Minor"
elif [[ "${age}" -le 65 ]]; then
    category="Adult"
else
    category="Senior"
fi

# Greeting message
greeting="Hello ${name} from ${country}! You are ${age} years old and classified as a ${category}."

echo "${greeting}"
log "User info recorded: ${greeting}"

echo "User information saved to ${LOG_FILE}
