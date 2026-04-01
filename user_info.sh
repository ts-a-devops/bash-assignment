#!/bin/bash

# This script prompts the user for user-info such as Name, Age, Country

LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/user_info.log"

# Create logs directory if it doesn't exist
mkdir -p "${LOG_DIR}"

# ==== NAME INPUT SECTION =======
read -p "What is your name? " name

if [[ -z "${name}" ]]; then
    echo "Invalid entry: Name cannot be empty. Exiting."
    exit 1
fi

echo "Pleased to meet you, ${name}!"
echo ""
sleep 2

# ==== AGE INPUT ======
read -p "What is your age? " age

if [[ -z "${age}" ]]; then
    echo "Invalid: Age cannot be empty. Exiting."
    exit 1
elif [[ ! "${age}" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid entry — age must be a numeric value. Exiting."
    exit 1
fi

# === AGE CATEGORY =====
if (( age < 18 )); then
    age_category="Minor"
elif (( age >= 18 && age <= 65 )); then
    age_category="Adult"
else
    age_category="Senior"
fi

echo "Hello ${name}, you confirmed your age as ${age} — you are categorised as a ${age_category}."
echo ""
sleep 2

# === COUNTRY INPUT ======
read -p "What country are you from? " country

if [[ -z "${country}" ]]; then
    echo "Error: Country cannot be empty. Exiting."
    exit 1
fi

# === FINAL GREETING ====
echo ""
echo " Hello ${name}!, you have confirmed your age  ${age} which means you are categorized a (${age_category} and you are from ${country}"

# ─── LOG OUTPUT ───────────────────────────────────────────────
{
    echo "========================================"
    echo "  Timestamp : $(date '+%Y-%m-%d %H:%M:%S')"
    echo "  Name      : ${name}"
    echo "  Age       : ${age} (${age_category})"
    echo "  Country   : ${country}"
    echo "========================================"
    echo ""
} >> "${LOG_FILE}"

