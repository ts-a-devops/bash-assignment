#!/usr/bin/env bash
# =============================================================================
# system_check.sh — Displays disk, memory, CPU load, process count, and top
#                   memory consumers. Warns on high disk usage. Logs report.
# =============================================================================
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_ROOT/logs"
DATE_TAG="$(date '+%Y-%m-%d')"
LOG_FILE="$LOG_DIR/system_report_${DATE_TAG}.log"

# Disk usage warning threshold (percentage)
DISK_WARN_THRESHOLD=80

# ── Ensure log directory exists ───────────────────────────────────────────────
mkdir -p "$LOG_DIR"

# ── Logging helper ────────────────────────────────────────────────────────────
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# ── Section header helper ─────────────────────────────────────────────────────
section() {
    local title="$1"
    echo "" | tee -a "$LOG_FILE"
    echo "════════════════════════════════════════" | tee -a "$LOG_FILE"
    echo "  $title" | tee -a "$LOG_FILE"
    echo "════════════════════════════════════════" | tee -a "$LOG_FILE"
}

# ── Disk usage check ──────────────────────────────────────────────────────────
check_disk() {
    section "DISK USAGE"
    df -h | tee -a "$LOG_FILE"

    # Iterate over each mounted filesystem and warn if usage exceeds threshold
    while IFS= read -r line; do
        # Extract the usage percentage (strip the % sign)
        usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
        mount=$(echo "$line" | awk '{print $6}')

        # Skip header line and non-numeric values
        if [[ "$usage" =~ ^[0-9]+$ ]]; then
            if (( usage > DISK_WARN_THRESHOLD )); then
                log "WARN" "High disk usage on $mount: ${usage}% (threshold: ${DISK_WARN_THRESHOLD}%)"
                echo "  ⚠  WARNING: $mount is at ${usage}% capacity!" | tee -a "$LOG_FILE"
            fi
        fi
    done < <(df -h | tail -n +2)
}

# ── Memory usage check ────────────────────────────────────────────────────────
check_memory() {
    section "MEMORY USAGE (MB)"
    free -m | tee -a "$LOG_FILE"
}

# ── CPU load check ────────────────────────────────────────────────────────────
check_cpu() {
    section "CPU LOAD (uptime)"
    uptime | tee -a "$LOG_FILE"
}

# ── Process count ─────────────────────────────────────────────────────────────
check_process_count() {
    section "TOTAL RUNNING PROCESSES"
    # Count all processes visible to the current user
    total=$(ps aux --no-headers | wc -l)
    echo "  Total processes: $total" | tee -a "$LOG_FILE"
    log "INFO" "Total running processes: $total"
}

# ── Top 5 memory-consuming processes ─────────────────────────────────────────
check_top_memory() {
    section "TOP 5 MEMORY-CONSUMING PROCESSES"
    # Sort by %MEM (column 4) descending, show top 5
    printf "%-10s %-8s %-8s %s\n" "PID" "%CPU" "%MEM" "COMMAND" | tee -a "$LOG_FILE"
    ps aux --no-headers --sort=-%mem | head -5 | \
        awk '{printf "%-10s %-8s %-8s %s\n", $2, $3, $4, $11}' | tee -a "$LOG_FILE"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
    log "INFO" "=== system_check.sh started ==="
    echo ""
    echo "  System Check Report — $(date '+%Y-%m-%d %H:%M:%S')"

    check_disk
    check_memory
    check_cpu
    check_process_count
    check_top_memory

    echo "" | tee -a "$LOG_FILE"
    log "INFO" "Report saved to: $LOG_FILE"
    log "INFO" "=== system_check.sh completed ==="
}

main "$@"
