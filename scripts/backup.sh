
LOG_DIR="$(dirname "$0")/../logs"
BACKUP_DIR="$(dirname "$0")/../backups"
LOG_FILE="$LOG_DIR/backup.log"
MAX_BACKUPS=5

mkdir -p "$LOG_DIR" "$BACKUP_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ── Validate input ───────────────────────
TARGET="$1"
if [[ -z "$TARGET" ]]; then
    log "ERROR: No directory provided."
    echo "Usage: $0 <directory>"
    exit 1
fi

if [[ ! -d "$TARGET" ]]; then
    log "ERROR: '$TARGET' is not a valid directory."
    echo "Error: Directory '$TARGET' does not exist."
    exit 1
fi

# ── Create backup ────────────────────────
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

log "Starting backup of '$TARGET' → '$BACKUP_PATH'"
tar -czf "$BACKUP_PATH" -C "$(dirname "$TARGET")" "$(basename "$TARGET")"

if [[ $? -eq 0 ]]; then
    SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
    log "SUCCESS: Backup '$BACKUP_NAME' created (size: $SIZE)."
    echo "✅ Backup created: $BACKUP_PATH ($SIZE)"
else
    log "FAILED: Backup of '$TARGET' failed."
    echo "❌ Backup failed."
    exit 1
fi

# ── Rotate: keep only last 5 backups ─────
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if (( BACKUP_COUNT > MAX_BACKUPS )); then
    EXCESS=$(( BACKUP_COUNT - MAX_BACKUPS ))
    log "Rotating backups — removing $EXCESS old backup(s)."
    ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n "$EXCESS" | while read -r OLD; do
        rm "$OLD"
        log "DELETED old backup: $(basename "$OLD")"
        echo "🗑️  Removed old backup: $(basename "$OLD")"
    done
fi

