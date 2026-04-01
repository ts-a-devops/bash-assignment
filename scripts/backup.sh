#!/bin/bash

# ── Setup ─────────────────────────────────────
BACKUP_DIR="../backups"
LOG_DIR="logs"
LOG_FILE="../logs/backup.log"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
MAX_BACKUPS=5


# ── Helpers ───────────────────────────────────
log() {
  local level="$1"
  local msg="$2"
  local entry="[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $msg"
  echo "$entry" | tee -a "$LOG_FILE"
}

info()    { log "INFO " "$1"; }
success() { log "OK   " "$1"; }
warn()    { log "WARN " "$1"; }
error()   { log "ERROR" "$1"; }

separator() {
  echo "---------------------------------------------" | tee -a "$LOG_FILE"
}

usage() {
  echo ""
  echo "Usage: ./backup.sh <source_directory>"
  echo ""
  echo "Example:"
  echo "  ./backup.sh /home/user/projects"
  echo "  ./backup.sh ./my_folder"
  echo ""
}

# ── Argument Guard ────────────────────────────
if [[ $# -lt 1 ]]; then
  error "No source directory provided."
  usage
  exit 1
fi

SOURCE_DIR="$1"

# ── Validate Source Directory ─────────────────
if [[ ! -e "$SOURCE_DIR" ]]; then
  error "Source '$SOURCE_DIR' does not exist."
  exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
  error "'$SOURCE_DIR' is not a directory."
  exit 1
fi

if [[ ! -r "$SOURCE_DIR" ]]; then
  error "Source '$SOURCE_DIR' is not readable. Check permissions."
  exit 1
fi

# ── Resolve directory name for archive naming ──
DIR_NAME=$(basename "$(realpath "$SOURCE_DIR")")
BACKUP_FILE="$BACKUP_DIR/backup_${DIR_NAME}_${TIMESTAMP}.tar.gz"

# ── Start Backup ──────────────────────────────
separator
info "Backup started."
info "Source      : $SOURCE_DIR"
info "Destination : $BACKUP_FILE"

tar -czf "$BACKUP_FILE" -C "$(dirname "$(realpath "$SOURCE_DIR")")" "$DIR_NAME" 2>/dev/null

TAR_EXIT=$?

if [[ $TAR_EXIT -ne 0 ]]; then
  error "Backup failed. tar exited with code $TAR_EXIT."
  exit 1
fi

# ── Verify archive was created ────────────────
if [[ ! -f "$BACKUP_FILE" ]]; then
  error "Backup file was not created: $BACKUP_FILE"
  exit 1
fi

BACKUP_SIZE=$(du -sh "$BACKUP_FILE" | awk '{print $1}')
success "Backup created successfully: $(basename "$BACKUP_FILE") ($BACKUP_SIZE)"

# ── Rotate: Keep Only Last 5 Backups ─────────
info "Checking backup rotation (max: $MAX_BACKUPS)..."

# List backups sorted oldest first
mapfile -t ALL_BACKUPS < <(ls -1t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null)
TOTAL=${#ALL_BACKUPS[@]}

if (( TOTAL > MAX_BACKUPS )); then
  DELETE_COUNT=$(( TOTAL - MAX_BACKUPS ))
  info "Found $TOTAL backup(s). Removing $DELETE_COUNT oldest backup(s)..."

  # Oldest are at the end of the ls -1t (newest-first) list
  for (( i = MAX_BACKUPS; i < TOTAL; i++ )); do
    OLD_FILE="${ALL_BACKUPS[$i]}"
    rm -f "$OLD_FILE"
    warn "Deleted old backup: $(basename "$OLD_FILE")"
  done
else
  info "Backup count is $TOTAL/$MAX_BACKUPS. No rotation needed."
fi

# ── Summary ───────────────────────────────────
separator
info "Backup Summary"
separator

REMAINING=( "$BACKUP_DIR"/backup_*.tar.gz )
COUNT=0
for f in "${REMAINING[@]}"; do
  [[ -f "$f" ]] || continue
  SIZE=$(du -sh "$f" | awk '{print $1}')
  MODIFIED=$(date -r "$f" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || stat -c "%y" "$f" | cut -d. -f1)
  info "  $(basename "$f")  [$SIZE]  $MODIFIED"
  (( COUNT++ ))
done

separator
success "Done. $COUNT backup(s) stored in '$BACKUP_DIR/'."
separator

