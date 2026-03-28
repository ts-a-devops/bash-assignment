#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mkdir -p logs backups

# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

# ========== Help ==================================================
show_help() {
    sed -n '/^##HELP_START/,/^##HELP_END/p' "$0" \
        | grep -v '^##HELP' \
        | sed 's/^# \{0,1\}//'
}

make_help() {
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║           backup.sh  —  Help                 ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
    show_help
}

##HELP_START
# DESCRIPTION
#   Create a compressed backup of a directory.
# USAGE
#   ./backup.sh <directory> [destination]
# EXAMPLES
#   ./backup.sh /home/user/documents
#   ./backup.sh /home/user/documents /mnt/backup
##HELP_END

[[ $# -eq 0 ]] && { make_help; exit 0; }
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && { make_help; exit 0; }

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
