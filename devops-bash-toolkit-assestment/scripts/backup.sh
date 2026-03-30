#!/bin/bash
set -euo pipefail

LOG_DIR="logs"
BACKUP_DIR="backups"
LOG_FILE="$LOG_DIR/backup.log"
MAX_BACKUPS=5
# ALL_CAPS: convention for constants in bash

mkdir -p "$LOG_DIR" "$BACKUP_DIR"
# mkdir -p accepts multiple directories at once

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

TARGET="${1:-}"
# $1: the directory passed as argument → ./backup.sh /some/dir

if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  echo "Error: '$TARGET' is not a valid directory."
  exit 1
fi
# -d: true if path exists AND is a directory (not a file)

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
# No spaces or colons — safe for use in filenames
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

log "Starting backup of '$TARGET'..."

tar -czf "$BACKUP_FILE" "$TARGET"
# tar: the standard Unix archive tool
# -c: create archive | -z: compress with gzip | -f: output filename follows

log "Backup created: $BACKUP_FILE"

BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
# ls -1: one file per line | 2>/dev/null: discard errors if no backups exist yet
# wc -l: count lines = count files

if [[ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]]; then
  DELETE_COUNT=$(( BACKUP_COUNT - MAX_BACKUPS ))
  # $(( )): arithmetic expansion — does math in bash

  ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n "$DELETE_COUNT" | xargs rm -f
  # ls -1t: list files sorted by time, newest first
  # tail -n N: get the last N lines = the oldest files
  # xargs rm -f: take each line as an argument and delete it

  log "Deleted $DELETE_COUNT old backup(s). Keeping last $MAX_BACKUPS."
fi

log "Backup complete."
