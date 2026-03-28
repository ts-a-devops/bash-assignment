#!/bin/bash
# file_manager.sh - File operations manager
# Usage: ./file_manager.sh <action> <source> [dest/pattern]
# Actions: create, delete, copy, move, rename, list, view, edit, search, backup
set -o errexit
set -o nounset
set -o pipefail

# ========== Paths ==================================================
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"
mkdir -p logs
LOG_FILE="logs/file_manager.log"

# ========== Help ==================================================
show_help() {
    sed -n '/^##HELP_START/,/^##HELP_END/p' "$0" \
        | grep -v '^##HELP' \
        | sed 's/^# \{0,1\}//'
}

make_help() {
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║           file_manager.sh  —  Help           ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
    show_help
}

##HELP_START
# DESCRIPTION
#   Manage files with a single unified command. Supports creating, deleting,
#   copying, moving, renaming, listing, viewing, searching, and backing up files.
#
# USAGE
#   ./file_manager.sh <action> <source> [dest/pattern]
#
# ACTIONS
#   create   <file>               Create a new empty file
#   delete   <file>               Delete a file
#   copy     <src>  <dest>        Copy src to dest (prompts if dest exists)
#   move     <src>  <dest>        Move src to dest (prompts if dest exists)
#   rename   <old>  <new>         Rename a file (dest must not already exist)
#   list     <dir>                List contents of a directory
#   view     <file>               Print file contents to stdout
#   edit     <file>               Open file in nano
#   search   <file> <pattern>     Search for a pattern inside a file (grep -n)
#   backup   <file>               Copy file to <file>.backup.<timestamp>
#
# EXAMPLES
#   ./file_manager.sh create  notes.txt
#   ./file_manager.sh delete  notes.txt
#   ./file_manager.sh copy    notes.txt  notes_copy.txt
#   ./file_manager.sh move    notes.txt  archive/notes.txt
#   ./file_manager.sh rename  old.txt    new.txt
#   ./file_manager.sh list    ./logs
#   ./file_manager.sh view    logs/file_manager.log
#   ./file_manager.sh search  logs/file_manager.log  "copy"
#   ./file_manager.sh backup  logs/file_manager.log
##HELP_END

[[ $# -eq 0 ]] && { make_help; exit 0; }
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && { make_help; exit 0; }

ACTION="${1}"; SOURCE="${2:-}"; DEST="${3:-}"

# ========== Config map: action -> cmd:source_rule:dest_rule:special ──────────────────
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

# ========== Dispatch map: action -> executor function ────────────────────────────────
declare -A DISPATCH=(
    ["search"]="exec_search"
    ["list"]="exec_display"
    ["view"]="exec_display"
    ["backup"]="exec_backup"
    ["copy"]="exec_two_arg"
    ["move"]="exec_two_arg"
    ["rename"]="exec_two_arg"
)

# ========== Validation ───────────────────────────────────────────────────────────────
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

# ========== Executor functions ───────────────────────────────────────────────────────
exec_search()  { echo "Matches for '$DEST' in '$SOURCE':"; echo "---"; $CMD "$DEST" "$SOURCE"; echo "---"; }
exec_display() { echo "Contents of '$SOURCE':";            echo "---"; $CMD "$SOURCE";          echo "---"; }
exec_backup()  { $CMD "$SOURCE" "$DEST"; echo -e "${GREEN}✓ Backed up to '$DEST'${NC}"; }
exec_two_arg() { $CMD "$SOURCE" "$DEST"; echo -e "${GREEN}✓ ${ACTION^}d '$SOURCE' → '$DEST'${NC}"; }
exec_default() { $CMD "$SOURCE";         echo -e "${GREEN}✓ ${ACTION^}d '$SOURCE'${NC}"; }

# ========== Parse config ─────────────────────────────────────────────────────────────
IFS=':' read -r CMD SOURCE_RULE DEST_RULE SPECIAL <<< "${CONFIG[$ACTION]:-}"
[[ -z "$CMD"     ]] && { echo -e "${RED}Error: Unknown action '$ACTION'${NC}"; exit 1; }
[[ -z "$SOURCE"  ]] && { echo -e "${RED}Error: Source file required${NC}";     exit 1; }
[[ "$SPECIAL" == *"requires_pattern"* && -z "$DEST" ]] && { echo -e "${RED}Error: Search pattern required${NC}"; exit 1; }

validate_rule "$SOURCE_RULE" "$SOURCE" "Source"
[[ -n "$DEST_RULE" && -n "$DEST" ]] && validate_rule "$DEST_RULE" "$DEST" "Destination"

# ========== Apply specials ────────────────────────────────────────────────────────────
[[ "$SPECIAL" == *"auto_dest"* ]] && DEST="${SOURCE}.backup.$(date +%Y%m%d_%H%M%S)"

# ========== Execute via dispatch map (falls back to exec_default) ────────────────────
echo -e "${GREEN}Action: $ACTION | Source: $SOURCE${NC}"
[[ -n "$DEST" ]] && echo "Destination: $DEST"

"${DISPATCH[$ACTION]:-exec_default}"

# ========== Log ==================================================
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $ACTION | $SOURCE${DEST:+ -> $DEST}" >> "$LOG_FILE"
echo -e "${GREEN}✓ Logged to $LOG_FILE${NC}"

