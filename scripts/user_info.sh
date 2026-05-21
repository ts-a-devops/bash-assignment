#!/bin/bash
# =============================================================================
# user_info.sh - Collect and validate user information
# =============================================================================

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/user_info.log"

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

# ── Helper: log a message with timestamp ─────────────────────────────────────
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ── Helper: determine age category ───────────────────────────────────────────
get_age_category() {
    local age=$1
    if   (( age < 18 ));  then echo "Minor"
    elif (( age <= 65 )); then echo "Adult"
    else                       echo "Senior"
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo "============================================"
echo "         User Information Collection        "
echo "============================================"

# --- Prompt for Name ---------------------------------------------------------
while true; do
    read -rp "Enter your name: " NAME
    NAME=$(echo "$NAME" | xargs)          # trim whitespace
    if [[ -z "$NAME" ]]; then
        echo "  ✖  Name cannot be empty. Please try again."
    else
        break
    fi
done

# --- Prompt for Age ----------------------------------------------------------
while true; do
    read -rp "Enter your age: " AGE
    AGE=$(echo "$AGE" | xargs)
    if [[ -z "$AGE" ]]; then
        echo "  ✖  Age cannot be empty. Please try again."
    elif ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
        echo "  ✖  Age must be a numeric value. Please try again."
    elif (( AGE < 0 || AGE > 150 )); then
        echo "  ✖  Please enter a realistic age (0–150)."
    else
        break
    fi
done

# --- Prompt for Country ------------------------------------------------------
while true; do
    read -rp "Enter your country: " COUNTRY
    COUNTRY=$(echo "$COUNTRY" | xargs)
    if [[ -z "$COUNTRY" ]]; then
        echo "  ✖  Country cannot be empty. Please try again."
    else
        break
    fi
done

# --- Build Output ------------------------------------------------------------
CATEGORY=$(get_age_category "$AGE")

echo ""
echo "============================================"
echo "               Your Information             "
echo "============================================"
echo "  Name    : $NAME"
echo "  Age     : $AGE ($CATEGORY)"
echo "  Country : $COUNTRY"
echo "============================================"
echo "  Hello, $NAME! Welcome from $COUNTRY."
echo "  You are classified as a $CATEGORY."
echo "============================================"
echo ""

# --- Save to Log -------------------------------------------------------------
log "User recorded — Name: $NAME | Age: $AGE | Category: $CATEGORY | Country: $COUNTRY"
echo "  ✔  Output saved to $LOG_FILE"