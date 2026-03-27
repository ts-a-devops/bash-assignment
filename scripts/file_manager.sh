#!/bin/bash
# file_manager.sh - File operations manager
# Usage: ./file_manager.sh <action> <source> [dest/pattern]
# Actions: create, delete, copy, move, rename, list, view, edit, search, backup
set -o errexit
set -o nounset
set -o pipefail

# ── Paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# mkdir -p "$SCRIPT_DIR/logs"
# LOG_FILE="$SCRIPT_DIR/logs/file_manager.log"
mkdir -p logs
LOG_FILE="logs/file_manager.log"

# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ── Guards ───────────────────────────────────────────────────────────────────
[[ $# -eq 0 ]] && { sed -n '3,10p' "$0" | grep -v "^#" || true; exit 0; }

ACTION="${1}"; SOURCE="${2:-}"; DEST="${3:-}"

# ── Config map: action -> cmd:source_rule:dest_rule:special ──────────────────
declare -A CONFIG=(
    ["create"]="touch:must_not_exist::"
    ["delete"]="rm -f:must_exist::"
    ["copy"]="cp:must_exist:ask:"
    ["move"]="mv:must_exist:ask:"
    ["rename"]="mv:must_exist:must_not_exist:"
    ["list"]="ls -lah:must_be_dir::"
    ["view"]="cat:must_exist::"
    ["edit"]="nano:must_exist::"
    ["search"]="grep -n:must_exist::requires_pattern"
    ["backup"]="cp:must_exist::auto_dest"
)

# ── Dispatch map: action -> executor function ────────────────────────────────
declare -A DISPATCH=(
    ["search"]="exec_search"
    ["list"]="exec_display"
    ["view"]="exec_display"
    ["backup"]="exec_backup"
    ["copy"]="exec_two_arg"
    ["move"]="exec_two_arg"
    ["rename"]="exec_two_arg"
)

# ── Validation ───────────────────────────────────────────────────────────────
validate_rule() {
    local rule="$1" path="$2" label="$3"
    [[ "$rule" == "must_exist"     ]] && [[ ! -e "$path" ]] && { echo -e "${RED}Error: $label '$path' not found${NC}";     exit 1; }
    [[ "$rule" == "must_not_exist" ]] && [[ -e  "$path" ]] && { echo -e "${RED}Error: $label '$path' already exists${NC}"; exit 1; }
    [[ "$rule" == "must_be_dir"    ]] && [[ ! -d "$path" ]] && { echo -e "${RED}Error: '$path' is not a directory${NC}";   exit 1; }
    [[ "$rule" == "ask"            ]] && [[ -e  "$path" ]] && {
        echo -e "${YELLOW}Warning: $label '$path' exists${NC}"
        read -r -p "Overwrite? (y/n): " -n 1; echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
    }
    return 0
}

# ── Executor functions ───────────────────────────────────────────────────────
exec_search()  { echo "Matches for '$DEST' in '$SOURCE':"; echo "---"; $CMD "$DEST" "$SOURCE"; echo "---"; }
exec_display() { echo "Contents of '$SOURCE':";            echo "---"; $CMD "$SOURCE";          echo "---"; }
exec_backup()  { $CMD "$SOURCE" "$DEST"; echo -e "${GREEN}✓ Backed up to '$DEST'${NC}"; }
exec_two_arg() { $CMD "$SOURCE" "$DEST"; echo -e "${GREEN}✓ ${ACTION^}d '$SOURCE' → '$DEST'${NC}"; }
exec_default() { $CMD "$SOURCE";         echo -e "${GREEN}✓ ${ACTION^}d '$SOURCE'${NC}"; }

# ── Parse config ─────────────────────────────────────────────────────────────
IFS=':' read -r CMD SOURCE_RULE DEST_RULE SPECIAL <<< "${CONFIG[$ACTION]:-}"
[[ -z "$CMD"     ]] && { echo -e "${RED}Error: Unknown action '$ACTION'${NC}"; exit 1; }
[[ -z "$SOURCE"  ]] && { echo -e "${RED}Error: Source file required${NC}";     exit 1; }
[[ "$SPECIAL" == *"requires_pattern"* && -z "$DEST" ]] && { echo -e "${RED}Error: Search pattern required${NC}"; exit 1; }

validate_rule "$SOURCE_RULE" "$SOURCE" "Source"
[[ -n "$DEST_RULE" && -n "$DEST" ]] && validate_rule "$DEST_RULE" "$DEST" "Destination"

# ── Apply specials ────────────────────────────────────────────────────────────
[[ "$SPECIAL" == *"auto_dest"* ]] && DEST="${SOURCE}.backup.$(date +%Y%m%d_%H%M%S)"

# ── Execute via dispatch map (falls back to exec_default) ────────────────────
echo -e "${GREEN}Action: $ACTION | Source: $SOURCE${NC}"
[[ -n "$DEST" ]] && echo "Destination: $DEST"

"${DISPATCH[$ACTION]:-exec_default}"

# ── Log ───────────────────────────────────────────────────────────────────────
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $ACTION | $SOURCE${DEST:+ -> $DEST}" >> "$LOG_FILE"
echo -e "${GREEN}✓ Logged to $LOG_FILE${NC}"