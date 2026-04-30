#!/usr/bin/env bash                                                                                                            
set -euo pipefail                                                                                                              
                                                                                                                           
# ============================================================================                                                 
# Obsidian + WhisperX (diarized transcription) + Fabric (Ollama glm-5:cloud)                                                 
# - If -a is omitted, auto-detect newest .m4a in Attachments/Audio or Attachments                                              
# ============================================================================                                                 
                                                                                                                               
# ----- CONFIG ---------------------------------------------------------------                                                 
WHISPERX_VENV="${WHISPERX_VENV:-$HOME/tools/whisperx-env}"                                                                     
WHISPERX_BIN="${WHISPERX_BIN:-$WHISPERX_VENV/bin/whisperx}"                                                                    
HF_TOKEN_FILE="${HF_TOKEN_FILE:-$HOME/.config/whisperx/token}"                                                                 
WHISPERX_DEVICE="${WHISPERX_DEVICE:-cpu}"                                                                                      
WHISPERX_COMPUTE="${WHISPERX_COMPUTE:-int8}"                                                                                   
WHISPERX_MODEL="${WHISPERX_MODEL:-small}"
WHISPERX_MIN_SPEAKERS="${WHISPERX_MIN_SPEAKERS:-}"
WHISPERX_MAX_SPEAKERS="${WHISPERX_MAX_SPEAKERS:-}"
                                                                                                                               
FABRIC_BIN="${FABRIC_BIN:-$HOME/go/bin/fabric}"                                                                  
FABRIC_PATTERN="${FABRIC_PATTERN:-ciso_minutes}"                                                                               
PATTERN_DIR="${PATTERN_DIR:-$HOME/.config/fabric/patterns}"

OLLAMA_URL="${OLLAMA_URL:-http://localhost:11434}"
OLLAMA_MODEL="${OLLAMA_MODEL:-glm-5:cloud}"

CURL_BIN="${CURL_BIN:-curl}"

green() { printf "\033[32m%s\033[0m\n" "$*"; }
yellow(){ printf "\033[33m%s\033[0m\n" "$*"; }
red()   { printf "\033[31m%s\033[0m\n" "$*"; }

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [-a /path/to/audio.m4a] -n /abs/path/to/note.md [-A /attachments/dir] [-k] | -d

Options:
  -a  Audio file (optional). If omitted, auto-detect newest .m4a in Attachments/Audio or Attachments
  -n  Absolute path to the Obsidian note to append to (required for normal run)
  -A  Attachments directory override (optional). If set, search here first.
  -k  Delete generated transcript .txt after insertion
  -d  Pre-flight diagnostics only

Env overrides:
  WHISPERX_VENV/WHISPERX_BIN/HF_TOKEN_FILE/WHISPERX_DEVICE/WHISPERX_COMPUTE
  FABRIC_BIN/FABRIC_PATTERN/PATTERN_DIR, OLLAMA_URL/OLLAMA_MODEL, CURL_BIN
EOF
}

# ----- helpers --------------------------------------------------------------
find_vault_root() {
  local start="$1"; local dir
  dir="$(dirname "$start")"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.obsidian" ]]; then
      printf "%s\n" "$dir"; return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

newest_m4a_in_dir() {
  local d="$1"
  [[ -d "$d" ]] || { return 0; }
  # shellcheck disable=SC2012
  ls -1t "$d"/*.m4a 2>/dev/null | head -n1 || true
}

auto_detect_audio() {
  local note_path="$1" attach_override="${2:-}"
  if [[ -n "$attach_override" ]]; then
    newest_m4a_in_dir "$attach_override" && return 0
  fi
  local vault
  if ! vault="$(find_vault_root "$note_path")"; then
    echo ""
    return 0
  fi
  local cand
  cand="$(newest_m4a_in_dir "$vault/Attachments/Audio")"; [[ -n "$cand" ]] && { echo "$cand"; return 0; }
  cand="$(newest_m4a_in_dir "$vault/Attachments")";       [[ -n "$cand" ]] && { echo "$cand"; return 0; }
  echo ""
 }

check_cmd() {
  local name="$1"; local bin="$2"; local required="${3:-yes}"
  if command -v "$bin" >/dev/null 2>&1; then
    green "PASS: $name ($bin) is available"
    return 0
  else
    if [[ "$required" == "yes" ]]; then
      red   "FAIL: $name ($bin) not found in PATH"
      return 1
    else
      yellow "WARN: $name ($bin) not found (optional)"
      return 0
    fi
  fi
}

check_file() {
  local desc="$1"; local path="$2"
  [[ -f "$path" ]] && { green "PASS: $desc found at $path"; return 0; }
  red "FAIL: $desc missing at $path"; return 1
}

preflight() {
  local ok=0
  echo "=== Pre-flight diagnostics ==="
  check_file "whisperx binary" "$WHISPERX_BIN" || ok=1
  if [[ -x "$WHISPERX_BIN" ]]; then
    green "PASS: whisperx is executable"
  else
    red "FAIL: whisperx is not executable at $WHISPERX_BIN"; ok=1
  fi
  check_file "HuggingFace token" "$HF_TOKEN_FILE" || ok=1
  check_cmd  "fabric CLI" "$FABRIC_BIN" || ok=1

  # robust pattern check (+ dry-run)
  if "$FABRIC_BIN" -l 2>/dev/null | tr -d '\r' | grep -qiE "\b${FABRIC_PATTERN}\b" \
     || echo "test" | "$FABRIC_BIN" -p "$FABRIC_PATTERN" --dry-run >/dev/null 2>&1; then
    green "PASS: Fabric pattern '${FABRIC_PATTERN}' available"
  else
    yellow "WARN: Fabric pattern '${FABRIC_PATTERN}' not listed; continuing anyway"
    echo   "HINT: Ensure ${PATTERN_DIR}/${FABRIC_PATTERN}/system.md and run 'fabric --setup' -> Custom Patterns ->
${PATTERN_DIR}; then 'fabric -U'"
  fi

  check_cmd "curl" "$CURL_BIN" || ok=1
  if "$CURL_BIN" -sS --connect-timeout 5 "${OLLAMA_URL}/api/tags" >/dev/null 2>&1; then
    green "PASS: Ollama reachable at ${OLLAMA_URL}"
    if "$CURL_BIN" -sS --connect-timeout 5 "${OLLAMA_URL}/api/tags" | grep -q "\"name\":\"${OLLAMA_MODEL}\""; then
      green "PASS: Ollama model '${OLLAMA_MODEL}' is pulled"
    else
      yellow "WARN: Ollama model '${OLLAMA_MODEL}' not found in /api/tags"
      echo   "HINT: ollama pull ${OLLAMA_MODEL}"
    fi
    if "$CURL_BIN" -sS --connect-timeout 5 "${OLLAMA_URL}/api/generate" -H "Content-Type: application/json" \
        -d "{\"model\":\"${OLLAMA_MODEL}\",\"prompt\":\"ping\",\"stream\":false}" | grep -q '"response"'; then
      green "PASS: Ollama generate responded for '${OLLAMA_MODEL}'"
    else
      red "FAIL: Ollama generate failed for '${OLLAMA_MODEL}'"; ok=1
    fi
  else
    red "FAIL: Ollama not reachable at ${OLLAMA_URL}"; ok=1
  fi

  if [[ $ok -eq 0 ]]; then
    green "Pre-flight: ALL CRITICAL CHECKS PASSED"; exit 0
  else
    red "Pre-flight: FAILED critical checks"; exit 2
  fi
}

# ----- args -----------------------------------------------------------------
AUDIO=""; NOTE=""; DELETE="no"; DIAG="no"; ATTACH_DIR_OVERRIDE=""

while getopts ":a:n:A:kdh" opt; do
  case $opt in
    a) AUDIO="$OPTARG" ;;
    n) NOTE="$OPTARG" ;;
    A) ATTACH_DIR_OVERRIDE="$OPTARG" ;;
    k) DELETE="yes" ;;
    d) DIAG="yes" ;;
    h) usage; exit 0 ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage; exit 2 ;;
    :)  echo "Option -$OPTARG requires an argument." >&2; usage; exit 2 ;;
  esac
done

if [[ "$DIAG" == "yes" ]]; then preflight; fi

[[ -z "$NOTE" ]] && { echo "Note (-n) is required."; usage; exit 2; }
[[ ! -f "$NOTE" ]] && { echo "Note not found: $NOTE" >&2; exit 2; }

# If -a not provided, auto-detect newest .m4a near the note's vault
if [[ -z "$AUDIO" ]]; then
  AUDIO="$(auto_detect_audio "$NOTE" "$ATTACH_DIR_OVERRIDE")"
  [[ -n "$AUDIO" ]] || { echo "No .m4a found. Provide -a or set -A to your attachments dir."; exit 2; }
fi

[[ -f "$AUDIO" ]] || { echo "Audio not found: $AUDIO" >&2; exit 2; }
[[ -x "$WHISPERX_BIN" ]] || { echo "whisperx not executable at: $WHISPERX_BIN" >&2; exit 2; }
[[ -f "$HF_TOKEN_FILE" ]] || { echo "HF token file missing at: $HF_TOKEN_FILE" >&2; exit 2; }

HF_TOKEN="$(cat "$HF_TOKEN_FILE")"

# ----- run ------------------------------------------------------------------
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
stem="$(basename "${AUDIO%.*}")"

# transcribe with diarization
# build optional speaker-count args
spk_args=()
[[ -n "$WHISPERX_MIN_SPEAKERS" ]] && spk_args+=(--min_speakers "$WHISPERX_MIN_SPEAKERS")
[[ -n "$WHISPERX_MAX_SPEAKERS" ]] && spk_args+=(--max_speakers "$WHISPERX_MAX_SPEAKERS")

"$WHISPERX_BIN" \
  --diarize \
  --hf_token "$HF_TOKEN" \
  --model "$WHISPERX_MODEL" \
  --language en \
  --compute_type "$WHISPERX_COMPUTE" \
  --device "$WHISPERX_DEVICE" \
  --output_dir "$tmp" \
  --output_format txt \
  "${spk_args[@]+"${spk_args[@]}"}" \
  "$AUDIO" >/dev/null 2>&1

TRANSCRIPT="$tmp/${stem}.txt"
[[ -f "$TRANSCRIPT" ]] || { echo "No transcript produced at: $TRANSCRIPT" >&2; exit 1; }

# minutes
MINUTES="$tmp/${stem}.minutes.md"
"$FABRIC_BIN" --pattern "$FABRIC_PATTERN" < "$TRANSCRIPT" > "$MINUTES"

# extract unique speaker IDs from transcript
SPEAKER_IDS=()
while IFS= read -r spk; do
  [[ -n "$spk" ]] && SPEAKER_IDS+=("$spk")
done < <(grep -oE "\[?SPEAKER_[0-9]+\]?" "$TRANSCRIPT" | tr -d '[]' | sort -u)

# build speakers mapping table
speakers_table="## Speakers -- ${stem}\n\n| ID | Name |\n|----|------|\n"
for spk in "${SPEAKER_IDS[@]}"; do
  speakers_table+="| ${spk} | ${spk} |\n"
done
speakers_table+="\n_Edit the Name column, then run the **Apply Speakers** template to rename throughout this block._"

# append to note
ts="$(date '+%Y-%m-%d %H:%M')"
{
  echo ""
  echo "<!-- MINUTES-BLOCK:${stem} -->"
  echo ""
  printf "%b\n" "$speakers_table"
  echo ""
  echo "## Transcript -- ${stem} (${ts})"
  echo ""
  cat "$TRANSCRIPT"
  echo ""
  echo "## Minutes -- ${stem}"
  echo ""
  cat "$MINUTES"
  echo ""
  echo "<!-- /MINUTES-BLOCK:${stem} -->"
} >> "$NOTE"

[[ "$DELETE" == "yes" ]] && rm -f "$TRANSCRIPT"

echo "Inserted transcript + minutes into: $NOTE"
echo "Audio: $AUDIO"

