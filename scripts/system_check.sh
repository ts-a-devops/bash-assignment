#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

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
    echo -e "${BOLD}${CYAN}║           system_check.sh  —  Help           ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
    show_help
}

# [[ $# -eq 0 ]] && { make_help; exit 0; }
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && { make_help; exit 0; }

##HELP_START
# DESCRIPTION
#   Check system usage and print a report.
# USAGE
#   ./system_check.sh [number_of_top_processes]
# EXAMPLES
#   ./system_check.sh # defaults to top 5 processes
#   ./system_check.sh 10 # shows top 10 processes
##HELP_END

# Get number of top processes from command line argument, default to 5
TOP_COUNT=${1:-5}

# Validate that TOP_COUNT is a positive number
if ! [[ "$TOP_COUNT" =~ ^[0-9]+$ ]] || [[ "$TOP_COUNT" -lt 1 ]]; then
    echo -e "${RED}Error: Please provide a positive number for top processes count${NC}"
    echo "Usage: $0 [number_of_top_processes]"
    exit 1
fi

echo "========== This program prints out system usage details =========="
echo "Showing top $TOP_COUNT memory-consuming processes"

mkdir -p logs

# Get Date
Date=$(date +"%Y-%m-%d %H:%M:%S")
log_date=$(date +"%Y%m%d_%H%M%S")
log_file="logs/system_report_${log_date}.log"

# Capture Multiline commands for Normal output
Disk_Usage=$(df -h)
Memory_usage=$(free -h)
Uptime=$(uptime -p)

# Parse Specific Values for Tabular View
disk_pct=$(df -Ph / | awk 'NR==2 {print $5}' | tr -d '%')
mem_used=$(free -h | awk 'NR==2 {print $3}')
mem_total=$(free -h | awk 'NR==2 {print $2}')
mem_summary="${mem_used}/${mem_total}"

# Count total running processes
total_processes=$(ps aux --no-headers | wc -l)

# Get top memory-consuming processes with headers
# Create a temporary file for consistent formatting
top_mem_data=$(ps aux --sort=-%mem | head -n $((TOP_COUNT + 1)))

# Check Disk Warning Threshold (> 80%)
disk_warning=false
if [[ "$disk_pct" =~ ^[0-9]+$ ]] && (( disk_pct > 80 )); then
    disk_status="WARNING (>80%)"
    disk_status_colored="${RED}WARNING${NC} (>80%)"
    disk_warning=true
else
    disk_status="OK"
    disk_status_colored="${GREEN}OK${NC}"
fi

# Print Normal format to Console
echo ""
echo "=== NORMAL FORMAT ==="
echo "Current Date & Time: $Date"
echo ""
echo "Disk Usage:"
echo "$Disk_Usage"
echo ""
echo "Memory Usage:"
echo "$Memory_usage"
echo ""
echo "Uptime:"
echo "$Uptime"
echo ""
echo "Total Running Processes: $total_processes"
echo ""
echo "Top $TOP_COUNT memory-consuming processes:"
# echo ""
echo "$top_mem_data"
echo ""

# Print Top Processes in Table Format with Headers
echo "=== TOP $TOP_COUNT MEMORY-CONSUMING PROCESSES ==="
# Print headers with better formatting
printf "${CYAN}%-8s | %-8s | %-8s | %-10s | %-50s${NC}\n" "USER" "%CPU" "%MEM" "VSZ" "COMMAND"
printf "%-8s | %-8s | %-8s | %-10s | %-50s\n" "--------" "--------" "--------" "----------" "--------------------------------------------------"

# Print process data (skip header row)
echo "$top_mem_data" | tail -n +2 | while IFS= read -r line; do
    # Parse the ps output
    user=$(echo "$line" | awk '{print $1}')
    cpu=$(echo "$line" | awk '{print $3}')
    mem=$(echo "$line" | awk '{print $4}')
    vsz=$(echo "$line" | awk '{print $5}')
    # Get command (everything after column 11)
    cmd=$(echo "$line" | cut -d' ' -f11- | cut -c1-50)

    # Color code memory usage if > 10%
    if (( $(echo "$mem > 10" | bc -l) )); then
        mem_display="${RED}$mem${NC}"
    elif (( $(echo "$mem > 5" | bc -l) )); then
        mem_display="${YELLOW}$mem${NC}"
    else
        mem_display="$mem"
    fi

    printf "%-8s | %-8s | %b | %-10s | %-50s\n" "$user" "$cpu" "$mem_display" "$vsz" "$cmd"
done

# Print Tabular System Summary to Console
echo ""
echo "=== SYSTEM SUMMARY (TABULAR FORMAT) ==="
printf "%-22s | %-13s | %-15s | %-35s | %b\n" "Date & Time" "Root Disk %" "Memory Use" "Uptime" "Disk Status"
printf "%-22s | %-13s | %-15s | %-35s | %s\n" "----------------------" "-------------" "---------------" "-----------------------------------" "---------------"
printf "%-22s | %-13s | %-15s | %-35s | %b\n" "$Date" "${disk_pct}%" "$mem_summary" "$Uptime" "$disk_status_colored"

# Active Warning Message
if [[ "$disk_warning" == true ]]; then
    echo ""
    echo -e "${RED} WARNING: Disk usage is at ${disk_pct}% which exceeds the 80% threshold! ${NC}"
    echo "${YELLOW} Consider freeing up disk space immediately to prevent system issues."
fi

# Write Everything to Log File (stripping ANSI colors)
{
    echo "========== System Usage Details =========="
    echo "Report Generated: $Date"
    echo "Top Processes Count: $TOP_COUNT"
    echo ""
    echo "=== NORMAL FORMAT ==="
    echo "Current Date & Time: $Date"
    echo ""
    echo "Disk Usage:"
    echo "$Disk_Usage"
    echo ""
    echo "Memory Usage:"
    echo "$Memory_usage"
    echo ""
    echo "Uptime:"
    echo "$Uptime"
    echo ""
    echo "Total Running Processes: $total_processes"
    echo ""

    echo "Top ${TOP_COUNT} Memory-Consuming Processes:"
    echo "$top_mem_data"
    echo ""

    echo "=== TOP $TOP_COUNT MEMORY-CONSUMING PROCESSES ==="
    printf "%-8s | %-8s | %-8s | %-10s | %-50s\n" "USER" "%CPU" "%MEM" "VSZ (KB)" "COMMAND"
    printf "%-8s | %-8s | %-8s | %-10s | %-50s\n" "--------" "--------" "--------" "----------" "--------------------------------------------------"

    # Write process data without colors
    echo "$top_mem_data" | tail -n +2 | while IFS= read -r line; do
        user=$(echo "$line" | awk '{print $1}')
        cpu=$(echo "$line" | awk '{print $3}')
        mem=$(echo "$line" | awk '{print $4}')
        vsz=$(echo "$line" | awk '{print $5}')
        cmd=$(echo "$line" | cut -d' ' -f11- | cut -c1-50)
        printf "%-8s | %-8s | %-8s | %-10s | %-50s\n" "$user" "$cpu" "$mem" "$vsz" "$cmd"
    done

    echo ""
    echo "=== SYSTEM SUMMARY (TABULAR FORMAT) ==="
    printf "%-22s | %-13s | %-15s | %-35s | %s\n" "Date & Time" "Root Disk %" "Memory Use" "Uptime" "Disk Status"
    printf "%-22s | %-13s | %-15s | %-35s | %s\n" "----------------------" "-------------" "---------------" "-----------------------------------" "---------------"
    printf "%-22s | %-13s | %-15s | %-35s | %s\n" "$Date" "${disk_pct}%" "$mem_summary" "$Uptime" "$disk_status"

    if [[ "$disk_warning" == true ]]; then
        echo ""
        echo "WARNING: Disk usage exceeded 80% threshold! Current usage: ${disk_pct}%"
    fi
} > "$log_file"

echo ""
echo -e "${GREEN}✓ Reports successfully saved to logs folder as: system_report_${log_date}.log${NC}"
echo -e "${CYAN}To view a different number of top processes, run: $0 [number]${NC}"

# ========== Tests =================================================
#
# HOW THIS WORKS
# ──────────────────────────────────────────────────────────────────
# Each scenario writes to a named temp file so that subsequent grep
# steps can read from disk (variables don't survive across eval calls
# in run_all.sh — see user_info.sh for full explanation).
#
# The log filename is dynamic (timestamp-based) so we grab the most
# recently created log file with: ls -t logs/system_report_*.log | head -1
#
##TEST_START
# bash ./scripts/system_check.sh > /tmp/sc_test_default.out 2>&1
# grep -q "This program prints out system usage details" /tmp/sc_test_default.out && echo "header ok"
# grep -q "Showing top 5" /tmp/sc_test_default.out && echo "default top count ok"
# grep -q "SYSTEM SUMMARY" /tmp/sc_test_default.out && echo "summary section ok"
# grep -q "Reports successfully saved" /tmp/sc_test_default.out && echo "save confirmation ok"
# ls logs/system_report_*.log 1>/dev/null 2>&1 && echo "log file created ok"
# latest_log=$(ls -t logs/system_report_*.log | head -1); grep -q "SYSTEM SUMMARY" "$latest_log" && echo "log content ok"
# latest_log=$(ls -t logs/system_report_*.log | head -1); grep -q "Disk Usage" "$latest_log" && echo "log has disk usage ok"
# latest_log=$(ls -t logs/system_report_*.log | head -1); grep -q "Memory Usage" "$latest_log" && echo "log has memory usage ok"
# latest_log=$(ls -t logs/system_report_*.log | head -1); grep -q "Uptime" "$latest_log" && echo "log has uptime ok"
# latest_log=$(ls -t logs/system_report_*.log | head -1); grep -q "Total Running Processes" "$latest_log" && echo "log has process count ok"
# latest_log=$(ls -t logs/system_report_*.log | head -1); cat "$latest_log" | LC_ALL=C grep -qv $'\\033' && echo "log has no ANSI codes ok"
# bash ./scripts/system_check.sh 3 > /tmp/sc_test_custom.out 2>&1
# grep -q "Showing top 3" /tmp/sc_test_custom.out && echo "custom top count ok"
# bash ./scripts/system_check.sh abc > /tmp/sc_test_badarg.out 2>&1; [[ $? -ne 0 ]] && echo "invalid arg exit code ok" || echo "FAIL: should have exited non-zero"
# grep -q "Please provide a positive number" /tmp/sc_test_badarg.out && echo "invalid arg message ok"
# bash ./scripts/system_check.sh 0 > /tmp/sc_test_zeroarg.out 2>&1; [[ $? -ne 0 ]] && echo "zero arg exit code ok" || echo "FAIL: should have exited non-zero"
# grep -q "Please provide a positive number" /tmp/sc_test_zeroarg.out && echo "zero arg message ok"
##TEST_END