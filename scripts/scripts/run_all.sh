#!/bin/bash

echo "Running all scripts..."

echo "1. User Info"
./scripts/user_info.sh

echo "2. System Check"
./scripts/system_check.sh

echo "3. File Manager"
./scripts/file_manager.sh

echo "4. Backup"
./scripts/backup.sh

echo "5. Process Monitor"
./scripts/process_monitor.sh nginx
