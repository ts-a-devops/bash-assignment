#!/bin/bash
# ─────────────────────────────────────────
#  backup.sh - Directory backup tool
# ─────────────────────────────────────────

# ── Folders ──
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"

# ── Create folders if they don't exist ──
mkdir -p "$BACKUP_DIR"
mkdir -p logs

# ── Timestamp ──
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# ── Function to print and log ──
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

log "========================================="
log "  BACKUP STARTED - $TIMESTAMP"
log "========================================="

# ── Check if a directory was provided ──
if [[ -z "$1" ]]; then
  log "[$TIMESTAMP] Error: No directory provided."
  echo ""
  echo "Usage: ./backup.sh <directory>"
  echo "Example: ./backup.sh /home/davis/projects"
  exit 1
fi

# ── Get the directory ──
SOURCE_DIR=$1

# ── Validate that the directory exists ──
if [[ ! -d "$SOURCE_DIR" ]]; then
  log "[$TIMESTAMP] Error: Directory '$SOURCE_DIR' does not exist."
  exit 1
fi

log "[$TIMESTAMP] INFO: Backing up directory '$SOURCE_DIR'..."

# ── Create compressed backup ──
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>/dev/null

# ── Check if backup was created successfully ──
if [[ $? -eq 0 ]]; then
  BACKUP_SIZE=$(du -sh "$BACKUP_FILE" | cut -f1)
  log "[$TIMESTAMP] SUCCESS: Backup created at '$BACKUP_FILE' (Size: $BACKUP_SIZE)"
else
  log "[$TIMESTAMP] Error: Backup failed for '$SOURCE_DIR'."
  exit 1
fi

# ── Keep only the last 5 backups ──
log "[$TIMESTAMP] INFO: Checking old backups..."

# Count total backups
TOTAL_BACKUPS=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [[ "$TOTAL_BACKUPS" -gt 5 ]]; then
  # Get backups older than the last 5 and delete them
  OLD_BACKUPS=$(ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6)

  for OLD_BACKUP in $OLD_BACKUPS; do
    rm "$OLD_BACKUP"
    log "[$TIMESTAMP] DELETED: Old backup '$OLD_BACKUP' removed."
  done
else
  log "[$TIMESTAMP] INFO: Total backups: $TOTAL_BACKUPS. No cleanup needed."
fi

# ── Show all current backups ──
log ""
log "--------- CURRENT BACKUPS ---------------"
ls -lh "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tee -a "$LOG_FILE"
log ""

log "========================================="
log "  BACKUP COMPLETED - $TIMESTAMP"
log "========================================="
