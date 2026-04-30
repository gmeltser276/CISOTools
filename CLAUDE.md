# CLAUDE.md

Instructions for AI agents working with this vault. Drop this file (or adapt it for your agent) into your vault's `.claude/` directory, `AGENTS.md`, or equivalent.

This is not a software project. There is no build system, test suite, or deployment pipeline. Edits are markdown files and Obsidian-specific formats.

## Vault Operations

- NEVER use `sed` for editing vault markdown files. `sed` fails on paths with spaces and markdown with pipe characters. Use `obsidian eval` or Python inline scripts instead.
- When writing to the vault, always use `path=` not `name=` to avoid creating duplicate files.
- Be aware that PreToolUse hooks may block Write/Edit tools for vault files. If blocked, fall back to Obsidian CLI commands via Bash immediately -- do not retry the blocked tool.

## Self-Healing Operations

### Write Fallbacks

If Write or Edit tools are blocked by hooks, immediately fall back to Obsidian CLI commands via Bash. Do not ask the user -- just switch and note the fallback.

### Sed Safety

Never use `sed` with pipe delimiters on markdown files. For find-and-replace on files containing markdown tables or special characters, use Python inline scripts instead.

### Post-Write Validation

Enforced by `vault-write-guard.sh` (see `hooks/`). The hook automatically checks after every Edit/Write:

- Single-line collapse (many bytes, 1 line)
- Truncation (>80% line or byte loss vs. pre-write baseline)
- Header loss (all markdown headers disappeared)
- Near-empty file (<10 bytes)

The hook is read-only and warns but never modifies files. If a warning fires, re-read the file and restore from Obsidian history if damaged.

### obsidian eval: inline vs. temp file

Use inline `obsidian eval code="..."` for single-bullet or single-sentence replacements. Escape bare dollar signs and use regex wildcard `.` instead of apostrophes when matching headings (e.g. `/## What we.re watching/`).

Use the temp file pattern for full section rewrites (more than ~10 lines, or content containing dollar signs, quotes, or backticks). Write to `/tmp/obsidian_*.txt`, load with `fs.readFileSync` inside eval, call `app.vault.modify`, then `fs.unlinkSync`. Trying to inline-escape complex multi-line content breaks silently.

## Vault Conventions

- Notes use Obsidian wiki-links (`[[note]]`) and Dataview inline fields
- **No data duplication.** When a note references information maintained elsewhere, use Obsidian embeds (`![[Note#Section]]` or `![[Note#^block-id]]`) or Dataview queries to pull live data from the single source of truth. Never copy tables, status fields, or team rosters between notes.
- **Timestamps:** `created` and `updated` frontmatter fields are managed by Templater. Do not manually set these.
- **Project lifecycle:** Notes move through `10. Projects/` -> `12. CompletedProjects/` or `13. StalledProjects/`. The `status` frontmatter property must match the folder location. When moving files, update both.
- **Status sections:** Active project notes should have a `## Current Status (Month Year)` section immediately after frontmatter summarizing owner, status, and key facts.

## Recommended Obsidian Plugins

Dataview, Tasks, Excalidraw, Templater, D2 diagrams, Mermaid, Charts.

## Meeting Dossier Rules

When prepping for meetings with external contacts, follow `templates/prompt-meeting-dossier.md`. Key rules:

- **Canonical facts live once.** Contract values, product specs, and bios belong in their canonical notes. Meeting notes reference via wikilink, never duplicate.
- **Meeting notes are time-scoped.** They capture context for one meeting, not running vendor state.
- **Bios live in People notes.** Meeting notes get a one-line engagement reminder per attendee (`[[Name]] -- one-line tactical guidance`), not a bio.
- **Frontmatter discipline.** Meeting notes must have `type: meeting-note`, `vendor:`, `attendees:` (full names), and `time:` (HH:MM, 24-hour) for Dataview queries.
- **Meeting `time:` is required.** If the user did not specify the meeting time, ask once before producing the note. Never invent or leave blank.
- **Outcomes + Action Items sections start empty.** Fill within 24 hours.

### Research pattern

1. Parallel vault research: `qmd` for concept matches, `obsidian search` for exact names, read existing hub / people / contract notes
2. Parallel web research: spawn a background agent for attendee profiles and organization offerings
3. Read current priorities from `Reference/<Year> Current Priorities.md`
4. Build People profiles (if missing) -> vendor hub (if missing) -> meeting note
5. Return paths and headline recommendations, not the full note body

---

## Obsidian CLI Reference

Use the Obsidian CLI for all markdown (`.md`) file interactions within the vault. Obsidian **must be running** -- the CLI communicates with the live app via IPC.

**Binary:** `/Applications/Obsidian.app/Contents/MacOS/obsidian`

On Linux (or WSL with WSLg): the binary location varies by install method. Run `which obsidian` or check your app directory.

Run `obsidian help` to see available commands.

### Syntax rules

```
param=value          # key=value for parameters; quote spaces: content="Hello world"
bare words           # boolean modifiers: silent, overwrite, verbose, counts, total, inline
--flag               # output control: --copy (copies output to clipboard)
\n \t                # literal newline / tab in content strings
```

### Targeting

| Parameter | Behavior |
|---|---|
| `file=<name>` | Resolves like a wikilink -- name only, no path or ext |
| `path=<path>` | Exact path from vault root, e.g. `folder/note.md` |
| `vault=<name>` | Target a specific vault -- MUST be the first parameter |
| (none) | Targets the active file open in Obsidian |

**Overwrite safety:** When using `overwrite`, always use `path=` not `name=`. The `name=` parameter resolves like a wikilink and silently creates a duplicate at vault root for notes in subdirectories -- the command returns "Created" instead of "Overwrote" with no error.

### Output formats

| Format | Best for |
|---|---|
| `json` | Scripts, jq pipelines, AI tool input |
| `csv` | Spreadsheet import, data analysis |
| `md` | Pasting into notes, readable terminal output |
| `paths` | Feeding to other CLI tools (`xargs`, etc.) |
| `yaml` | Config files, frontmatter-compatible output |
| `tree` | Folder structure visualization |
| `tsv` | Terminal processing with `awk`/`cut` |

Universal modifiers: `total` (count only), `verbose` (with extra detail), `counts` (include frequency counts), `format=<fmt>` (output format), `--copy` (copy to clipboard).

### Files and Folders

```bash
# List
obsidian files                                       # all files in vault
obsidian files folder="<YourOrg>/10. Projects"       # files in folder
obsidian files ext=md format=json                    # JSON list of markdown files
obsidian files total                                 # count notes in vault
obsidian folders                                     # list all folders
obsidian folders format=tree                         # hierarchical tree view

# Read
obsidian read file="Home"
obsidian read path="<YourOrg>/10. Projects/Password Manager.md"

# Create
obsidian create name="2026-03-03 Vendor Meeting" content="# Meeting\n\n## Attendees" silent
obsidian create name="Script" path="Content/" template="YouTube Script"
obsidian create path="folder/Existing Note.md" content="new full content" overwrite
```

**Preferred pattern for multi-line content: bash heredoc**

```bash
CONTENT=$(cat << 'HEREDOC'
---
title: Note Title
tags:
  - example
---
# Note content here
HEREDOC
)
obsidian create \
  path="folder/Note Name.md" \
  content="$CONTENT" \
  overwrite silent
```

Only fall back to the temp file approach when content contains characters that break variable expansion.

```bash
# Append / prepend
obsidian append file="Home" content="\n- [ ] Follow up on SIEM vendor"
obsidian prepend file="Home" content="## Added\n\n"
obsidian append file="Log" content="entry text" inline   # no trailing newline

# Move / rename / delete
obsidian move file="Draft Note" to="<YourOrg>/10. Projects/Draft Note.md"  # .md required
obsidian rename file="Draft Note" name="Final Note"
obsidian delete file="Old Note"           # moves to Obsidian trash
obsidian delete file="Old Note" permanent # irreversible

# Other
obsidian open file="Home"                 # open in Obsidian GUI
obsidian open file="Home" newtab          # open in new tab
obsidian wordcount file="Note"            # word and character count
obsidian random:read                      # read a random note
obsidian recents                          # recently opened files
```

### Modifying Existing Notes (Targeted Replacement)

Use `obsidian eval` for find-and-replace within notes. This runs JavaScript in Obsidian's runtime using `app.vault.read()` and `app.vault.modify()` -- the same API that plugins use. Writes go through the file watcher, trigger sync correctly, and create version history entries.

**Do NOT use `sed` or `awk` on vault `.md` files.** Direct disk writes bypass Obsidian's file watcher and sync. If the note is open in Obsidian, this can cause corruption.

**Pattern: single replacement**

```bash
obsidian eval code="(async () => {
  const f = app.vault.getAbstractFileByPath('path/to/note.md');
  let c = await app.vault.read(f);
  c = c.replace('old text', 'new text');
  await app.vault.modify(f, c);
  return 'done';
})()"
```

**Pattern: batch replacements (atomic)**

```bash
obsidian eval code="(async () => {
  const f = app.vault.getAbstractFileByPath('path/to/note.md');
  let c = await app.vault.read(f);
  const reps = [
    ['old text 1', 'new text 1'],
    ['old text 2', 'new text 2'],
  ];
  let n = 0;
  for (const [o, r] of reps) {
    if (c.includes(o)) { c = c.replace(o, r); n++; }
  }
  await app.vault.modify(f, c);
  return n + ' replacements';
})()"
```

**Pattern: large edits via temp file**

Write new content to a temp file, then use eval to read it and write to the vault. `require('fs')` is available in Obsidian's Electron runtime.

```bash
# 1. Write updated content to /tmp/obsidian_update.txt
# 2. Then:
obsidian eval code="(async () => {
  const fs = require('fs');
  const content = fs.readFileSync('/tmp/obsidian_update.txt', 'utf8');
  const f = app.vault.getAbstractFileByPath('path/to/note.md');
  await app.vault.modify(f, content);
  fs.unlinkSync('/tmp/obsidian_update.txt');
  return 'updated';
})()"
```

**Rules:**
- Must wrap in async IIFE -- top-level `await` is not supported in eval
- Use `.replaceAll()` for global replacements (all occurrences, not just first)
- Always return a count or confirmation so you know what changed
- Verify results with `obsidian read` after complex edits
- Clean up temp files after use

### CLI Gotchas

- `obsidian tags:rename` is not available in this CLI version. To rename tags, use `obsidian eval` to find-and-replace tag strings in each affected file individually.
- `obsidian move` fails with ENOENT if the target folder does not exist. Create a placeholder file in the target folder first, then move.
- `obsidian search` does not find `#tags` in body text or YAML frontmatter. Use `obsidian tag name="tagname"` for tag lookups, or `obsidian search query="[tag:name]"` for structured tag queries.

### Search

```bash
obsidian search query="SIEM migration" limit=10
obsidian search query="threat model" matches             # show surrounding context
obsidian search query="meeting" path="<YourOrg>" limit=20 format=json
obsidian search query="[tag:publish]"                   # tag-based search
obsidian search query="[tag:project] [tag:active]"      # multiple tags
obsidian search query="[status:active]"                 # property-based
obsidian search query="[priority:>3]"                   # property comparison
obsidian search query="SIEM" case                       # case-sensitive
obsidian search query="TODO" total                      # count matches only
obsidian search:open query="[tag:review]"               # open search in Obsidian UI
```

### Tasks

```bash
obsidian tasks                                    # tasks from today's daily note
obsidian tasks all todo                           # all incomplete tasks in vault
obsidian tasks all done format=json               # all completed tasks as JSON
obsidian tasks file="Home" verbose                # tasks with file paths + line numbers
obsidian tasks total                              # count tasks
obsidian task ref="<YourOrg>/Home.md:42" toggle   # toggle by file:line reference
obsidian task file=Recipe line=8 done             # set task done
obsidian task file=Recipe line=8 todo             # set task not done
obsidian task file=Recipe line=8 status=-         # set task cancelled
```

### Tags

```bash
obsidian tags all counts                          # all tags with counts
obsidian tags all counts sort=count               # sorted by frequency
obsidian tags file="Project Alpha"                # tags on a specific file
obsidian tags total                               # total tag count
obsidian tag name="project" verbose               # files tagged #project with details
```

### Properties (YAML Frontmatter)

```bash
obsidian properties all counts sort=count         # all properties sorted by frequency
obsidian properties file="Project Alpha"          # all properties of a note
obsidian properties name="status"                 # files that have the 'status' property
obsidian property:read name="status" file="Note"
obsidian property:set name="status" value="active" file="Note"
obsidian property:set name="due" value="2026-04-15" type=date file="Note"
obsidian property:set name="tags" value="security,ai" type=tags file="Note"
obsidian property:remove name="draft" file="Note"
# Types: text | list | number | checkbox | date | tags
```

### Links and Vault Health

```bash
obsidian backlinks file="Home"                    # notes that link TO this note
obsidian backlinks file="Home" counts             # with link counts
obsidian links file="Home"                        # outgoing links from note
obsidian links file="Home" total                  # count outgoing links
obsidian outline file="Home"                      # headings tree
obsidian outline file="Home" format=md            # headings as markdown

# Vault health
obsidian orphans                                  # notes with no incoming links
obsidian orphans total
obsidian deadends                                 # notes with no outgoing links
obsidian unresolved                               # broken [[wikilinks]] across vault
obsidian unresolved counts                        # with reference counts
obsidian unresolved verbose                       # with source file details
```

### Bookmarks

```bash
obsidian bookmarks                                # list all bookmarks
obsidian bookmark file="Work/note.md"             # bookmark a file
obsidian bookmark file="note.md" subpath="#heading"  # bookmark a heading
obsidian bookmark search="TODO"                   # bookmark a search query
```

### Bases (Database Views)

```bash
obsidian bases                                    # list all .base files
obsidian base:views                               # views in current base
obsidian base:query file="MyBase"                 # query base (default format)
obsidian base:query file="MyBase" format=json     # JSON output
obsidian base:query file="MyBase" format=md       # markdown table
obsidian base:query file="MyBase" view="View Name"  # query specific view
obsidian base:create name="New Item"              # create item in current base view
```

### Templates

```bash
obsidian templates                                # list available templates
obsidian template:read name="Daily"               # read template content
obsidian template:read name="Daily" resolve title="My Note"  # with variables resolved
obsidian template:insert name="Daily"             # insert template into active file
```

### History and Diff (File Recovery)

```bash
obsidian history file="Note"                      # list version history
obsidian history:read file="Note" version=2       # read a specific version
obsidian history:restore file="Note" version=2    # restore a version
obsidian diff file="Note" from=1 to=3             # diff between versions
```

### Workspaces and Tabs

```bash
obsidian workspaces                               # list saved workspaces
obsidian workspace:save name="coding"             # save current layout
obsidian workspace:load name="coding"             # load saved workspace
obsidian tabs                                     # list open tabs
obsidian tab:open file="Work/note.md"             # open file in new tab
```

### Plugins

```bash
obsidian plugins                                  # list all installed plugins
obsidian plugins:enabled filter=community versions  # enabled community plugins with versions
obsidian plugin:enable id=dataview
obsidian plugin:disable id=dataview
obsidian plugin:install id=dataview enable        # install and enable
obsidian plugin:reload id=my-plugin               # reload (dev workflow)
```

### Developer / Automation

```bash
# Execute JavaScript in Obsidian's full runtime context
obsidian eval code="app.vault.getFiles().length"
obsidian eval code="Object.keys(app.plugins.plugins).join(', ')"

# Screenshots
obsidian dev:screenshot path=~/Downloads/vault.png

# Console (requires dev:debug on first)
obsidian dev:debug on
obsidian dev:console limit=50
obsidian dev:console level=error

# General
obsidian vault                                    # vault name, path, file count, size
obsidian vaults                                   # list all known vaults
obsidian reload                                   # reload the vault
```

---

## Semantic Search (qmd)

qmd provides hybrid semantic search (BM25 + vector embeddings + LLM reranking) over the indexed vault. Install via `bun install -g @tobilu/qmd` and configure as an MCP server (see `config/mcp.json.example`).

### When to use qmd vs obsidian search

| Situation | Use |
|---|---|
| You know the exact term, tag, or property | `obsidian search` |
| You want concept/intent-based results | `qmd` |
| You need a specific file by path | `obsidian read` |
| You need several related files at once | `qmd` |
| Results seem stale or incomplete | `qmd embed` first, then `qmd` |

Do NOT use qmd for: tag queries, property filters, task searches, daily notes, or vault health checks. `obsidian search` with structured syntax is faster and more accurate for those.

### Query types

| Type | Syntax | Best for |
|---|---|---|
| Keyword (BM25) | `searches: [{type:'lex', query:'error handling'}]` | Exact terms, fast lookup |
| Semantic (vector) | `searches: [{type:'vec', query:'how to handle errors'}]` | Meaning-based search |
| Hypothetical doc | `searches: [{type:'hyde', query:'quarterly planning'}]` | Write what the answer looks like |
| Combined (best) | `[{type:'lex', query:'SIEM'}, {type:'vec', query:'SIEM migration decisions'}]` | Keyword + semantic together |

Always provide an `intent` parameter on search calls to disambiguate and improve snippet quality. The `intent` param forces full LLM expansion (bypasses fast-path); use it when higher-quality reranking matters.

**Hyde caveat:** Avoid hyphenated words (e.g. `poc` not `proof-of-concept`) -- qmd tokenizes hyphens as lex negation operators.

### Retrieval

- `get` -- single document by path or docid (`#abc123`). Supports `fromLine` / `maxLines` for partial retrieval.
- `multi_get` -- batch retrieve by glob pattern or comma-separated list. Glob: use collection-relative paths (e.g. `vendors/*.md`, not `ObsidianVault/vendors/*.md`).
- `status` -- index health and collection info.

---

## Which Tool When

| Operation | `.md` files in vault | Non-markdown files |
|---|---|---|
| **Read** | `obsidian read` | Built-in `Read` tool |
| **Search by content** | `obsidian search query=...` | `grep` / `rg` |
| **Search with context** | `obsidian search query=... matches` | `grep` / `rg` |
| **Search by tag** | `obsidian search query="[tag:name]"` | N/A |
| **Search by property** | `obsidian search query="[prop:value]"` | N/A |
| **Add content** | `obsidian append` / `obsidian prepend` | Built-in `Edit` tool |
| **Create new** | `obsidian create name=... silent` | Built-in `Write` tool |
| **Full rewrite** | `obsidian create path=... content=... overwrite` | Built-in `Write` tool |
| **Targeted replacement** | `obsidian eval` (read-modify-write) | Built-in `Edit` tool |
| **Full rewrite (large)** | `obsidian eval` + temp file | Built-in `Write` tool |
| **Set properties** | `obsidian property:set` | N/A |
| **List files** | `obsidian files folder=...` | `ls` / `find` |
| **Vault health** | `obsidian orphans` / `unresolved` / `deadends` | N/A |
| **Search by concept** | `qmd query` | N/A |
| **Fetch known file** | `qmd get` or `obsidian read` | N/A |
| **Batch fetch related** | `qmd multi_get` | N/A |
