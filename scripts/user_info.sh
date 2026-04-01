#!/usr/bin/env bash
# user_info.sh - Collect and validate user information
set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/user_info.log"
mkdir -p "$LOG_DIR"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

get_age_category() {
  local age=$1
  if   (( age < 18  )); then echo "Minor"
  elif (( age <= 65  )); then echo "Adult"
  else                        echo "Senior"
  fi
}

while true; do
  read -rp "Enter your name: " NAME
  NAME="${NAME//[[:space:]]/}"            # strip whitespace
  [[ -n "$NAME" ]] && break
  echo "  Name cannot be empty. Please try again."
done
 
while true; do
  read -rp "Enter your age: " AGE
  if [[ "$AGE" =~ ^[0-9]+$ ]] && (( AGE >= 0 && AGE <= 150 )); then
    break
  fi
  echo "  Age must be a whole number between 0 and 150. Please try again."
done


while true; do
  read -rp "Enter your country: " COUNTRY
  COUNTRY="${COUNTRY#"${COUNTRY%%[![:space:]]*}"}"   # ltrim
  COUNTRY="${COUNTRY%"${COUNTRY##*[![:space:]]}"}"   # rtrim
  [[ -n "$COUNTRY" ]] && break
  echo "  Country cannot be empty. Please try again."
done

CATEGORY=$(get_age_category "$AGE")

OUTPUT="

  Name    : $NAME
  Age     : $AGE ($CATEGORY)
  Country : $COUNTRY

    Hello, $NAME! Welcome from $COUNTRY.
    You are classified as: $CATEGORY
"

echo "$OUTPUT"
log "User recorded — Name: $NAME | Age: $AGE ($CATEGORY) | Country: $COUNTRY"
echo "$OUTPUT" >> "$LOG_FILE"
