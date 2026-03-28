#!/usr/bin/env bash
# =============================================================================
# backup.sh — Creates a compressed .tar.gz backup of a given directory,
#             stores it in backups/, and retains only the last 5 backups.
#
# Usage:
#   ./backup.sh <directory_to_backup>
# =============================================================================
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_ROOT/logs"
BACKUP_DIR="$PROJECT_ROOT/backups"
LOG_FILE="$LOG_DIR/backup.log"

# Maximum number of backups to retain
MAX_BACKUPS=5

# ── Ensure required directories exist ────────────────────────────────────────
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

# ── Logging helper ────────────────────────────────────────────────────────────
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# ── Usage ─────────────────────────────────────────────────────────────────────
usage() {
    echo ""
    echo "Usage: $(basename "$0") <directory_to_backup>"
    echo ""
    echo "  Creates a compressed backup of the specified directory."
    echo "  Backups are stored in: $BACKUP_DIR"
    echo "  Only the last $MAX_BACKUPS backups are kept."
    echo ""
}

# ── Create backup ─────────────────────────────────────────────────────────────
create_backup() {
    local source_dir="$1"

    # Resolve to absolute path for clarity in logs
    source_dir="$(realpath "$source_dir")"

    # Validate that the source directory exists
    if [[ ! -d "$source_dir" ]]; then
        log "ERROR" "Source directory does not exist: '$source_dir'"
        echo "  ✗  Directory '$source_dir' not found." >&2
        exit 1
    fi

    # Build a timestamped archive name using the directory's basename
    local dir_name
    dir_name="$(basename "$source_dir")"
    local timestamp
    timestamp="$(date '+%Y%m%d_%H%M%S')"
    local archive_name="backup_${dir_name}_${timestamp}.tar.gz"
    local archive_path="$BACKUP_DIR/$archive_name"

    log "INFO" "Starting backup of '$source_dir' → '$archive_path'"
    echo "  ⏳  Backing up '$source_dir'..."

    # Create the compressed archive; -C changes to parent so paths are relative
    tar -czf "$archive_path" -C "$(dirname "$source_dir")" "$dir_name"

    # Confirm the archive was created and report its size
    local size
    size="$(du -sh "$archive_path" | cut -f1)"
    log "INFO" "Backup created: '$archive_name' (size: $size)"
    echo "  ✔  Backup created: $archive_name ($size)"
}

# ── Prune old backups ─────────────────────────────────────────────────────────
prune_old_backups() {
    # List backups sorted by modification time (oldest first), keep last MAX_BACKUPS
    local backup_count
    backup_count="$(find "$BACKUP_DIR" -maxdepth 1 -name "backup_*.tar.gz" | wc -l)"

    if (( backup_count > MAX_BACKUPS )); then
        local excess=$(( backup_count - MAX_BACKUPS ))
        log "INFO" "Found $backup_count backups; removing $excess oldest to keep last $MAX_BACKUPS."
        echo "  🗑   Removing $excess old backup(s)..."

        # Sort by time (oldest first) and delete the excess
        find "$BACKUP_DIR" -maxdepth 1 -name "backup_*.tar.gz" -printf '%T+ %p\n' \
            | sort \
            | head -n "$excess" \
            | awk '{print $2}' \
            | while IFS= read -r old_backup; do
                rm -f "$old_backup"
                log "INFO" "Removed old backup: '$(basename "$old_backup")'"
                echo "    ✗  Removed: $(basename "$old_backup")"
            done
    else
        log "INFO" "Backup count ($backup_count) within limit ($MAX_BACKUPS). No pruning needed."
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
    if [[ $# -lt 1 ]]; then
        log "ERROR" "No directory argument provided."
        usage
        exit 1
    fi

    log "INFO" "=== backup.sh started ==="

    create_backup "$1"
    prune_old_backups

    log "INFO" "=== backup.sh completed ==="
}

main "$@"
