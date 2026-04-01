#!/bin/bash

DATE=$(date +%F)
BACKUP_DIR=~/backup

mkdir -p $BACKUP_DIR

echo "Creating backup..."

tar -czf $BACKUP_DIR/project_$DATE.tar.gz .

echo "Backup saved to $BACKUP_DIR"

