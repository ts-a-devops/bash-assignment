#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mkdir -p logs

# ========== Colors ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ========== Fallback Array ==========
services=("nginx" "ssh" "docker")

# ========== Input Logic ==========
if [[ $# -gt 0 ]]; then
    PROCESS_NAMES=("$@")
else
    echo -e "${YELLOW}No input provided. Defaulting to predefined services array.${NC}"
    PROCESS_NAMES=("${services[@]}")
fi

# ========== Main Logic ==========

echo -e "${YELLOW}Monitoring processes: ${PROCESS_NAMES[*]}${NC}"

while true; do
    # Check if processes are running
    for PROCESS_NAME in "${PROCESS_NAMES[@]}"; do
        #! NOTE: this doesn't work well with process aliases
        # you have to provide the exact binary name of the process for this to catch it
        # if pgrep -x "$PROCESS_NAME" > /dev/null 2>&1; then

        # this works well with process aliases
        # it matches the process name anywhere in the process table
        if pgrep -f "(^|/)$PROCESS_NAME" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Process '${PROCESS_NAME}': Running${NC}"
            echo "[$(date +"%Y-%m-%d %H:%M:%S")] Process '${PROCESS_NAME}': Running" >> "logs/process_monitor.log"
        else
            echo -e "${RED}✗ Process '${PROCESS_NAME}': Stopped${NC}"
            echo "[$(date +"%Y-%m-%d %H:%M:%S")] Process '${PROCESS_NAME}': Stopped" >> "logs/process_monitor.log"

            # Simulate Restart
            echo -e "${YELLOW}  Simulating restart for '${PROCESS_NAME}'...${NC}"
            sleep 1
            echo -e "${GREEN}✓ Process '${PROCESS_NAME}': Restarted${NC}"
            echo "[$(date +"%Y-%m-%d %H:%M:%S")] Process '${PROCESS_NAME}': Restarted" >> "logs/process_monitor.log"
        fi
    done

    sleep 5
    # Comment out exit 0 for continous monitoring
    exit 0
done
