#!/bin/bash
# shellcheck disable=SC1091
source "$(dirname "$0")/scripts/colors.sh"

# ─── Counters ────────────────────────────────────────────────────────────────
PASS=0
FAIL=0
SKIP=0
declare -a FAILURES   # collects "scriptname: command" for the summary

SCRIPTS_DIR="$(dirname "$0")/scripts"

# ─── Per-script runner ───────────────────────────────────────────────────────
run_tests_for() {
    local script="$1"
    local script_name
    script_name=$(basename "$script")

    # Extract everything between ##TEST_START and ##TEST_END,
    # strip the leading "# " (or "#") that marks each command line,
    # drop blank lines.
    local test_block
    test_block=$(sed -n '/^##TEST_START/,/^##TEST_END/p' "$script" \
        | grep -v '^##TEST' \
        | sed 's/^#[[:space:]]*//' \
        | grep -v '^[[:space:]]*$')

    if [[ -z "$test_block" ]]; then
        echo -e "${YELLOW} [SKIP]${NC} $script_name — no ##TEST block found"
        (( SKIP++ ))
        echo ""
        return
    fi

    echo -e "${BOLD}${CYAN}▶ $script_name${NC}"

    local step=0
    while IFS= read -r cmd; do
        (( step++ ))
        echo -e "  ${DIM}step $step »${NC} $cmd"

        # Run the command; capture output so we can show it on failure
        local out
        if out=$(eval "$cmd" 2>&1); then
            echo -e "  ${GREEN}[PASS]${NC}"
            (( PASS++ ))
        else
            echo -e "  ${RED}[FAIL]${NC} exit code: $?"
            # Show what the command actually printed, indented
            if [[ -n "$out" ]]; then
                echo "$out" | sed 's/^/         /'
            fi
            FAILURES+=("$script_name  step $step: $cmd")
            (( FAIL++ ))
        fi
    done <<< "$test_block"

    echo ""
}

# ─── Header ──────────────────────────────────────────────────────────────────
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║           run_all.sh  —  Test Runner         ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# ─── Discover and run ────────────────────────────────────────────────────────
for script in "$SCRIPTS_DIR"/*.sh; do
    run_tests_for "$script"
done

# ─── Summary ─────────────────────────────────────────────────────────────────
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║                  Summary                     ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo -e "  ${GREEN}Passed : $PASS${NC}"
echo -e "  ${RED}Failed : $FAIL${NC}"
echo -e "  ${YELLOW}Skipped: $SKIP${NC}"

if (( FAIL > 0 )); then
    echo ""
    echo -e "${RED}${BOLD}Failed steps:${NC}"
    for entry in "${FAILURES[@]}"; do
        echo -e "  ${RED}✗${NC} $entry"
    done
fi

echo ""
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
