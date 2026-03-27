#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mkdir -p logs backups

# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ========== Guards ==================================================
[[ $# -eq 0 ]] && {
    sed -n '3,10p' "$0" | grep -v "^#" || true;
    exit 0;
}

DIR_TO_BACKUP="${1}"
DESTINATION_OF_BACKUP="${2-./backups}"

# Define guard checks as an associative array
declare -A checks=(
    ["-z \"$DIR_TO_BACKUP\""]="Error: No directory specified"
    ["! -d \"$DIR_TO_BACKUP\""]="Error: Directory not found"
)

# Loop through each check
for test in "${!checks[@]}"; do
    if eval "[[ $test ]]"; then
        echo -e "${RED}${checks[$test]}${NC}"
        exit 1
    fi
done

# ========== Create Compressed Backup ==================================================

timestamp=$(date +"%Y%m%d_%H%M%S")
mkdir -p "$DESTINATION_OF_BACKUP"
backup_file="${DESTINATION_OF_BACKUP}/backup_${timestamp}.tar.gz"
log_file="logs/backup.log"

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Starting backup of '${DIR_TO_BACKUP}' to '${backup_file}'" >> "$log_file"

echo -e "${YELLOW}Gathering file list for progress calculation...${NC}"
TOTAL_FILES=$(find "$DIR_TO_BACKUP" 2>/dev/null | wc -l)
[[ "$TOTAL_FILES" -eq 0 ]] && TOTAL_FILES=1 # Prevent division by zero

echo -e "${GREEN}Creating compressed backup...${NC}"
# Use tar in verbose mode and pipe to awk to create an elegant progress bar
if tar -vczf "$backup_file" "$DIR_TO_BACKUP" 2>/dev/null | awk -v total="$TOTAL_FILES" '
    BEGIN { bar="==================================================" }
    {
        count++
        pct = int((count / total) * 100)
        if (pct > 100) pct = 100
        bars = int((pct / 100) * 50)
        printf "\r[%s%s] %d%% (%d/%d)", substr(bar, 1, bars), sprintf("%*s", 50-bars, ""), pct, count, total
    }
    END { print "" }
'; then
    echo -e "${GREEN}✓ Backup created successfully: ${backup_file}${NC}"
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] ✓ Successfully created ${backup_file}" >> "$log_file"
else
    echo -e "${RED}Error: Backup failed${NC}"
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] ❌ Failed to create ${backup_file}" >> "$log_file"
    exit 1
fi

echo -e "${YELLOW}Cleaning up old backups (keeping last 5)...${NC}"
shopt -s nullglob
# Get array of backups sorted by modification time (newest first)
mapfile -t backups < <(ls -t "${DESTINATION_OF_BACKUP}"/backup_*.tar.gz 2>/dev/null || true)

if [[ ${#backups[@]} -gt 5 ]]; then
    # Slice the array to get elements from index 5 onwards (the older ones)
    old_backups=("${backups[@]:5}")
    for old in "${old_backups[@]}"; do
        rm -f "$old"
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] Deleted old backup: $old" >> "$log_file"
    done
    echo -e "${GREEN}✓ Removed ${#old_backups[@]} old backup(s)${NC}"
fi

echo -e "${GREEN}Backup process complete!${NC}"
exit 0
