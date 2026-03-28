#!/usr/bin/env bash
# =============================================================================
# user_info.sh — Collects user information, validates input, categorizes age,
#                and logs all activity with timestamps.
# =============================================================================
set -euo pipefail

# ── Paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/user_info.log"

# ── Ensure log directory exists ───────────────────────────────────────────────
mkdir -p "$LOG_DIR"

# ── Logging helper ────────────────────────────────────────────────────────────
# Writes a timestamped message to both stdout and the log file.
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# ── Validate that a value is a positive integer ───────────────────────────────
validate_age() {
    local age="$1"
    # Check that the value contains only digits and is not empty
    if [[ ! "$age" =~ ^[0-9]+$ ]]; then
        return 1
    fi
    # Reject unrealistic ages
    if (( age < 0 || age > 130 )); then
        return 1
    fi
    return 0
}

# ── Determine age category ────────────────────────────────────────────────────
get_age_category() {
    local age="$1"
    if (( age < 18 )); then
        echo "Minor"
    elif (( age <= 65 )); then
        echo "Adult"
    else
        echo "Senior"
    fi
}

# ── Prompt for a non-empty string ─────────────────────────────────────────────
prompt_non_empty() {
    local prompt_text="$1"
    local value=""
    while [[ -z "$value" ]]; do
        read -rp "$prompt_text" value
        if [[ -z "$value" ]]; then
            echo "  ⚠  Input cannot be empty. Please try again." >&2
        fi
    done
    echo "$value"
}

# ── Main logic ────────────────────────────────────────────────────────────────
main() {
    log "INFO" "=== user_info.sh started ==="

    echo ""
    echo "╔══════════════════════════════════╗"
    echo "║       User Information Form      ║"
    echo "╚══════════════════════════════════╝"
    echo ""

    # Collect Name
    name="$(prompt_non_empty "Enter your name: ")"
    log "INFO" "Name entered: $name"

    # Collect and validate Age
    while true; do
        read -rp "Enter your age: " age
        if validate_age "$age"; then
            break
        else
            echo "  ⚠  Invalid age. Please enter a whole number between 0 and 130." >&2
            log "WARN" "Invalid age input: '$age'"
        fi
    done
    log "INFO" "Age entered: $age"

    # Collect Country
    country="$(prompt_non_empty "Enter your country: ")"
    log "INFO" "Country entered: $country"

    # Determine category
    category="$(get_age_category "$age")"

    # Build output
    echo ""
    echo "──────────────────────────────────────"
    echo "  Hello, $name! Welcome from $country."
    echo "  Age: $age  →  Category: $category"
    echo "──────────────────────────────────────"
    echo ""

    # Log final result
    log "INFO" "Result — Name: $name | Age: $age | Country: $country | Category: $category"
    log "INFO" "=== user_info.sh completed ==="
}

main "$@"
