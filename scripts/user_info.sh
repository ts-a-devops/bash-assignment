#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_DIR="${PROJECT_ROOT}/logs"
LOG_FILE="${LOG_DIR}/user_info.log"

mkdir -p "${LOG_DIR}"

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "${LOG_FILE}"
}

read -r -p "Enter your name: " name
read -r -p "Enter your age: " age
read -r -p "Enter your country: " country

if [[ -z "${name}" || -z "${age}" || -z "${country}" ]]; then
  message="Missing input. Name, age, and country are all required."
  echo "${message}"
  log_message "${message}"
  exit 1
fi

if [[ ! "${age}" =~ ^[0-9]+$ ]]; then
  message="Invalid age '${age}'. Age must be numeric."
  echo "${message}"
  log_message "${message}"
  exit 1
fi

if (( age < 18 )); then
  category="Minor"
elif (( age <= 65 )); then
  category="Adult"
else
  category="Senior"
fi

message="Hello, ${name} from ${country}. You are classified as: ${category}."
echo "${message}"
