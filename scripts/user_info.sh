

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/user_info.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ── Prompt for Name ──────────────────────
read -rp "Enter your name: " NAME
if [[ -z "$NAME" ]]; then
    log "ERROR: Name cannot be empty."
    exit 1
fi

# ── Prompt for Age ───────────────────────
read -rp "Enter your age: " AGE
if [[ -z "$AGE" ]]; then
    log "ERROR: Age cannot be empty."
    exit 1
fi
if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
    log "ERROR: Age must be a numeric value. Got: '$AGE'"
    echo "Invalid age. Please enter a number."
    exit 1
fi

# ── Prompt for Country ───────────────────
read -rp "Enter your country: " COUNTRY
if [[ -z "$COUNTRY" ]]; then
    log "ERROR: Country cannot be empty."
    exit 1
fi

# ── Determine Age Category ───────────────
if (( AGE < 18 )); then
    CATEGORY="Minor"
elif (( AGE <= 65 )); then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

# ── Output ───────────────────────────────
OUTPUT="
========================================
  Hello, $NAME!
  Age     : $AGE ($CATEGORY)
  Country : $COUNTRY
  Welcome to the DevOps Bash Toolkit!
========================================"

echo "$OUTPUT"
log "User recorded — Name: $NAME | Age: $AGE ($CATEGORY) | Country: $COUNTRY"

