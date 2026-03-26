#!/bin/bash
# =============================================
# user_info.sh - Collects and logs user information
# =============================================

set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

# Colors for nice output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a logs/user_info.log
}

echo -e "${GREEN}=== User Information Tool ===${NC}"

# Get input with validation
read -rp "Enter your Name: " name
while [[ -z "$name" ]]; do
    echo -e "${RED}Name cannot be empty!${NC}"
    read -rp "Enter your Name: " name
done

read -rp "Enter your Age: " age
while ! [[ "$age" =~ ^[0-9]+$ ]]; do
    echo -e "${RED}Age must be a numeric value!${NC}"
    read -rp "Enter your Age: " age
done

read -rp "Enter your Country: " country
while [[ -z "$country" ]]; do
    echo -e "${RED}Country cannot be empty!${NC}"
    read -rp "Enter your Country: " country
done

# Determine age category
if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

# Output greeting
echo -e "\n${GREEN}Hello, ${name}!${NC}"
echo -e "You are from ${YELLOW}${country}${NC} and you are ${YELLOW}${age} years old${NC} (${category})."

# Log everything
log "User: $name | Age: $age ($category) | Country: $country"

echo -e "${GREEN} Information saved to logs/user_info.log${NC}"
