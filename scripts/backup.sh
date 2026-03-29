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

DIR_TO_BACKUP="${1-}"
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


# ========== Tests =================================================
#
# HOW THIS WORKS
# ──────────────────────────────────────────────────────────────────
# logs/ is used as the backup source — always exists, always has content.
# Two destination targets are used:
#   /tmp/test_backups  — custom dest tests (cleaned up after)
#   ./backups          — default dest test
#
##TEST_START
# bash ./scripts/backup.sh --help > /tmp/bk_test_help.out 2>&1
# grep -q "DESCRIPTION" /tmp/bk_test_help.out && echo "help output ok"
# bash ./scripts/backup.sh > /tmp/bk_test_noarg.out 2>&1
# grep -q "DESCRIPTION" /tmp/bk_test_noarg.out && echo "no arg shows help ok"
# bash ./scripts/backup.sh /nonexistent_dir_xyz > /tmp/bk_test_baddir.out 2>&1; [[ $? -ne 0 ]] && echo "bad dir exit code ok" || echo "FAIL: should have exited non-zero"
# grep -q "Directory not found" /tmp/bk_test_baddir.out && echo "bad dir message ok"
# bash ./scripts/backup.sh logs /tmp/test_backups > /tmp/bk_test_custom.out 2>&1
# grep -q "Backup created successfully" /tmp/bk_test_custom.out && echo "custom dest backup success ok"
# ls /tmp/test_backups/backup_*.tar.gz 1>/dev/null 2>&1 && echo "custom dest backup file exists ok"
# tar -tzf "$(ls -t /tmp/test_backups/backup_*.tar.gz | head -1)" 1>/dev/null 2>&1 && echo "backup archive is valid tar.gz ok"
# bash ./scripts/backup.sh logs > /tmp/bk_test_default.out 2>&1
# grep -q "Backup created successfully" /tmp/bk_test_default.out && echo "default dest backup success ok"
# ls ./backups/backup_*.tar.gz 1>/dev/null 2>&1 && echo "default dest backup file exists in backups/ ok"
# tail -10 logs/backup.log | grep -q "Starting backup" && echo "log has start entry ok"
# tail -10 logs/backup.log | grep -q "Successfully created" && echo "log has success entry ok"
# mkdir -p /tmp/test_backups && for i in 1 2 3 4 5 6; do touch "/tmp/test_backups/backup_20200101_00000${i}.tar.gz"; done
# bash ./scripts/backup.sh logs /tmp/test_backups > /tmp/bk_test_cleanup.out 2>&1
# count=$(ls /tmp/test_backups/backup_*.tar.gz 2>/dev/null | wc -l); [[ "$count" -le 5 ]] && echo "old backup cleanup ok (kept $count)" || echo "FAIL: found $count backups, expected max 5"
# rm -rf /tmp/test_backups
##TEST_END
