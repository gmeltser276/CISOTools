#!/usr/bin/env bash
set -euo pipefail

PHASE="${1:?Usage: vault-write-guard.sh <pre|post>}"
VAULT="${VAULT_WRITE_GUARD_DIR:?Set VAULT_WRITE_GUARD_DIR to your Obsidian vault path}"
GUARD_DIR="${TMPDIR:-/tmp}/claude-vault-guard"

INPUT=$(cat)

FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""')

[[ -z "$FILE" ]] && exit 0
[[ "$FILE" != "$VAULT"/* ]] && exit 0
[[ "$FILE" != *.md ]] && exit 0

mkdir -p "$GUARD_DIR"
HASH=$(echo -n "$FILE" | md5 -q 2>/dev/null || md5sum <<< "$FILE" | cut -d' ' -f1)
BASELINE="$GUARD_DIR/$HASH.json"

if [[ "$PHASE" == "pre" ]]; then
    [[ ! -f "$FILE" ]] && exit 0

    LINES=$(wc -l < "$FILE" | tr -d ' ')
    BYTES=$(wc -c < "$FILE" | tr -d ' ')
    HEADERS=$(grep -c '^##' "$FILE" || true)

    jq -n \
        --arg file "$FILE" \
        --argjson lines "$LINES" \
        --argjson bytes "$BYTES" \
        --argjson headers "$HEADERS" \
        '{file:$file,lines:$lines,bytes:$bytes,headers:$headers}' \
        > "$BASELINE"
    exit 0
fi

[[ ! -f "$FILE" ]] && { echo "VAULT WRITE GUARD: File missing after write: $FILE"; exit 0; }

NOW_LINES=$(wc -l < "$FILE" | tr -d ' ')
NOW_BYTES=$(wc -c < "$FILE" | tr -d ' ')
NOW_HEADERS=$(grep -c '^##' "$FILE" || true)
WARN=""

if (( NOW_LINES <= 1 && NOW_BYTES > 100 )); then
    WARN+="COLLAPSE: ${NOW_BYTES} bytes on ${NOW_LINES} line(s). "
fi

if [[ -f "$BASELINE" ]]; then
    PREV_LINES=$(jq -r '.lines' "$BASELINE")
    PREV_BYTES=$(jq -r '.bytes' "$BASELINE")
    PREV_HEADERS=$(jq -r '.headers' "$BASELINE")

    if (( PREV_LINES > 5 && NOW_LINES > 0 )); then
        PCT=$(( NOW_LINES * 100 / PREV_LINES ))
        if (( PCT < 20 )); then
            WARN+="TRUNCATED: ${PREV_LINES} -> ${NOW_LINES} lines (${PCT}%). "
        fi
    fi

    if (( PREV_BYTES > 100 && NOW_BYTES > 0 )); then
        PCT=$(( NOW_BYTES * 100 / PREV_BYTES ))
        if (( PCT < 20 )); then
            WARN+="SHRUNK: ${PREV_BYTES} -> ${NOW_BYTES} bytes (${PCT}%). "
        fi
    fi

    if (( PREV_HEADERS > 0 && NOW_HEADERS == 0 )); then
        WARN+="HEADERS LOST: Had ${PREV_HEADERS}, now 0. "
    fi

    rm -f "$BASELINE"
fi

if (( NOW_BYTES < 10 )); then
    WARN+="NEAR-EMPTY: Only ${NOW_BYTES} bytes. "
fi

if [[ -n "$WARN" ]]; then
    echo "VAULT WRITE GUARD: ${WARN}"
    echo "  File: $FILE"
    echo "  Now: ${NOW_LINES} lines, ${NOW_BYTES} bytes, ${NOW_HEADERS} headers"
    echo "  ACTION: Re-read the file. If damaged, restore via: obsidian history file=\"<name>\""
fi

exit 0
