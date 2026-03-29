#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mkdir -p logs

# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

# ==================================================
show_help() {
    sed -n '/^##HELP_START/,/^##HELP_END/p' "$0" \
        | grep -v '^##HELP' \
        | sed 's/^# \{0,1\}//'
}

make_help() {
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║           process_monitor.sh  —  Help        ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
    show_help
}

##HELP_START
# DESCRIPTION
#   Monitor processes and restart them if they are not running.
# USAGE
#   ./process_monitor.sh [process1] [process2] ...
# EXAMPLES
#   ./process_monitor.sh nginx ssh docker
#   ./process_monitor.sh # uses default services array: nginx, ssh, docker
##HELP_END

# [[ $# -eq 0 ]] && { make_help; exit 0; }
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && { make_help; exit 0; }

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


# ========== Tests =================================================
#
# HOW THIS WORKS
# ──────────────────────────────────────────────────────────────────
# process_monitor.sh runs one full pass then exits (exit 0 inside
# the while loop). This makes it directly testable.
#
# "bash" is used as the guaranteed-running process.
# "fakeservice_xyz" is used as the guaranteed-stopped process.
#
# Default array test: called with no args, should fall through to
# services=("nginx" "ssh" "docker") and monitor all three.
# Requires [[ $# -eq 0 ]] guard to be commented out.
#
##TEST_START
# bash ./scripts/process_monitor.sh --help > /tmp/pm_test_help.out 2>&1
# grep -q "DESCRIPTION" /tmp/pm_test_help.out && echo "help output ok"
# bash ./scripts/process_monitor.sh bash > /tmp/pm_test_running.out 2>&1
# grep -q "Running" /tmp/pm_test_running.out && echo "running process detected ok"
# test -f logs/process_monitor.log && echo "log file created ok"
# bash ./scripts/process_monitor.sh fakeservice_xyz > /tmp/pm_test_stopped.out 2>&1
# grep -q "Stopped" /tmp/pm_test_stopped.out && echo "stopped process detected ok"
# grep -q "Restarted" /tmp/pm_test_stopped.out && echo "restart simulation ok"
# tail -20 logs/process_monitor.log | grep -q "Running" && echo "log has running entry ok"
# tail -20 logs/process_monitor.log | grep -q "Stopped" && echo "log has stopped entry ok"
# tail -20 logs/process_monitor.log | grep -q "Restarted" && echo "log has restarted entry ok"
# bash ./scripts/process_monitor.sh bash fakeservice_xyz > /tmp/pm_test_multi.out 2>&1
# grep -q "Running" /tmp/pm_test_multi.out && echo "multi-arg running ok"
# grep -q "Stopped" /tmp/pm_test_multi.out && echo "multi-arg stopped ok"
# bash ./scripts/process_monitor.sh > /tmp/pm_test_defaults.out 2>&1
# grep -q "nginx" /tmp/pm_test_defaults.out && echo "default services: nginx present ok"
# grep -q "ssh" /tmp/pm_test_defaults.out && echo "default services: ssh present ok"
# grep -q "docker" /tmp/pm_test_defaults.out && echo "default services: docker present ok"
##TEST_END
