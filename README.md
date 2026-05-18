# CISOTools

A CISO's AI-augmented knowledge management system. Markdown vault + AI agent tooling for daily security leadership work: meeting prep, committee updates, legislative analysis, diarized minutes, and vault integrity guardrails.

Built on Obsidian and Claude Code, assumes you are running this on a Mac. The principles and most artifacts are agent-agnostic -- adaptable to OpenAI Codex, Claude CoWork, Cursor, or any agent harness that reads markdown and runs shell commands. The vault itself is plain markdown files; All of this easily ported to windows (see below).

**Origin:** Companion repo for the State CISO Session on AI-accelerated vault workflows. Everything here is a working reference from a production CISO deployment at the State of Connecticut.

## What this solves

A second-brain, AI-referenceable CISO workflow over your day-to-day work and data.

- **Externalizes your thinking** into a structured knowledge base you own, so decisions, relationships, and context survive beyond your head, your inbox, and your tenure.
- **Makes the AI useful** by grounding it in your reality (your priorities, your team, your vendors, your agencies) instead of generic training data. Retrieval over generation.
- **Compounds with every use.** Each meeting note, vendor hub, and bill analysis enriches the corpus the AI reads next week.
- **Scales a single CISO.** Hours of solo research, drafting, and prep become minutes of directed review.
- **Stays portable.** Markdown files, plain-text prompts, version-controlled skills. Nothing locked in a vendor's cloud.

## Quick start

1. Install [Claude Code](https://claude.com/claude-code) (or your agent of choice).
2. Copy `config/settings.json.example` to `~/.claude/settings.json`. The deny list is the most important part.
3. The Bash audit log hook starts logging immediately.
4. Install the `episodic-memory` and `last30days` plugins (see [Plugins](#plugins)).
5. Pick one workflow template from `templates/`. Drop it in your vault's `Templates/` folder.

## Repository layout

```
CISOTools/
  config/                           Example agent configuration
    settings.json.example             Global deny list, hooks, model config
    settings.local.json.example       Per-vault write boundary + integrity hooks
    mcp.json.example                  MCP server definitions
  hooks/                            Vault integrity scripts
    vault-write-guard.sh              Pre/post write integrity checker
  skills/                           Claude Code skills (SKILL.md-based)
    legislative-bill-analysis/        State bill analysis, 8 CISO impact domains
    humanizer/                        Removes 50+ AI writing patterns
    reflection/                       Config self-audit from CLAUDE.md + settings
    function-review/                  Code quality checklist
    what-did-i-say/                   Search past conversation prompts
    talk-panel-review/                 Expert panel critique for talk scripts
  scripts/                          Pipeline scripts
    obsidian_fabric_minutes.sh        WhisperX + Fabric diarized minutes pipeline
    run_ciso_minutes.js               Obsidian Templater glue for minutes pipeline
    apply_speakers.js                 Rename SPEAKER_00 labels to real names
  patterns/                         Fabric prompt patterns
    ciso_minutes/system.md            Meeting minutes with rationalization reject-list
  templates/                        Obsidian vault templates
    prompt-meeting-dossier.md         Parallel-research meeting prep
    prompt-committee-update.md        Two-phase committee update builder
    tpl-meeting-note.md               Meeting note structure
    tpl-ciso-minutes.md               Templater trigger for minutes pipeline
    apply-speakers.md                 Templater trigger for speaker rename
  CLAUDE.md                           Agent instructions for vault operations
```

## Vault structure

The vault is the data. AI is the lens. Recommended folder skeleton for your Obsidian Vault (this is entirely up to you and how you work and organize. AI will adopt to it. 

```
<YourOrg>/
    Reference/                (canonical sources: priorities, RACI, team directory)
    10. Projects/             (active initiatives)
    11. UpcomingProjects/     (planned)
    12. CompletedProjects/    (shipped)
    13. StalledProjects/      (blocked)
    Vendors/                  (one note per vendor relationship)
    People/<Org>/             (one note per external contact)
    Meetings/<Org>/           (time-scoped, one per meeting)
    Partners/                 (federal, regional, ISAC)
    Agencies/                 (per-agency notes)
    Presentations/            (talk notes, scripts, process docs)
Templates/                    (reusable templates and prompts)
Attachments/                  (audio, images, PDFs)
.claude/                      (agent config -- or .codex/, AGENTS.md, etc.)
```

**Four rules that keep the vault usable:**

1. **No data duplication.** Contract figures, bios, project status live in exactly one canonical note. Everything else uses wikilinks or Obsidian embeds (`![[Note#Section]]` or `![[Note#^block-id]]`). Never copy tables, status fields, or team rosters between notes.
2. **Status is the folder.** Project notes move between `10. Projects` and `12. CompletedProjects` as state changes. Frontmatter `status:` mirrors the folder. When moving files, update both.
3. **Time-scoped versus canonical.** Meeting notes are for one date. Vendor hubs are permanent. The two do not mix.
4. **Status sections on active projects.** Each note in `10. Projects/` should have a `## Current Status (Month Year)` section immediately after frontmatter summarizing owner, status, and key facts.

**Three Reference notes form the spine ( and you need to create these) :**

- `Reference/<Year> Current Priorities.md` -- annual or quarterly priorities, owner-linked
- `Reference/Team Directory.md` -- your direct team, RACI, contact infoa, who does what, etc. 
- `Reference/Security Operations Domains.md` -- your org's capabilities, leads, tools, status. 

The AI reads these on every workflow to set context.

### GTD layer

GTD stands for "Getting Things Done" and is a fundamental element of how I strucuture my work. You should read the concise overview here: https://hamberg.no/gtd/ Five tags cover every action state (alongside project/person tags). CLAUDE.md knows about these tags and you can ask your Agent questions like "what's due next week?" etc:

| Tag | Meaning |
|---|---|
| `#in` | Stuff that just landed, not yet sorted. Everything arrives here first. |
| `#NextActions` | Do as soon as possible. The working list. |
| `#WaitingFor` | Delegated, waiting on someone or something. Reviewed weekly. |
| `#Projects` | Anything requiring more than two actions. Each gets its own note. |
| `#Someday` | Parking lot. Good ideas that are not now. |

Folders represent lifecycle state; tags represent action state. A project in `10. Projects/` can contain tasks tagged `#NextActions`, `#WaitingFor`, and `#Someday` all at once.

### Recommended Obsidian plugins

These community plugins make the vault workflows function for me. 

| Plugin | Purpose |
|---|---|
| [Dataview](https://github.com/blacksmithgu/obsidian-dataview) | Query notes as a database (tables, lists, task aggregation). This has largely been replaced by Obsidian bases, but I haven't migrated yet. |
| [Tasks](https://github.com/obsidian-tasks-group/obsidian-tasks) | Task management with due dates, recurrence, filters |
| [Templater](https://github.com/silentvoid13/Templater) | Template engine that runs JavaScript (drives the minutes pipeline) |
| [Excalidraw](https://github.com/zsviczian/obsidian-excalidraw-plugin) | Whiteboard diagrams embedded in notes. I use it when I need to quickly sketch something |
| [Mermaid](https://mermaid.js.org/) | Built into Obsidian core -- flowcharts, sequence diagrams, Gantt charts |
| [Charts](https://github.com/phibr0/obsidian-charts) | Chart.js visualizations inside notes |

## Agent configuration

### Hardening (all agents)

The deny list in `config/settings.json.example` blocks the agent from reading credentials, SSH keys, cloud CLI tokens, keychains, and from running destructive commands. This is the most important single configuration.

Source: simplified from [Trail of Bits Claude Code config](https://github.com/trailofbits/claude-code-config). The full security rationale lives there. Go through that repo and install what you feel you need. 

### Three core hooks for my config:

| Hook | Purpose | Failure mode it closes |
|---|---|---|
| `PreToolUse` (Bash) | Blocks destructive `rm` commands | Accidental file destruction |
| `PostToolUse` (Bash) | Logs every command with timestamp to `~/.claude/bash-commands.log` | Missing audit trail |
| `Stop` (LLM judge) | Rejects responses that rationalize incomplete work | Agent claiming "done" when it is not |

### Vault write-guard

`hooks/vault-write-guard.sh` is a read-only integrity checker. Wire it into your vault's local agent settings (see `config/settings.local.json.example`). It:

- Baselines line count, byte size, and header count before any write
- Compares after the write
- Warns on: single-line collapse, truncation (>80% line/byte loss), header loss, near-empty files
- Never modifies files

**Setup:** Set the `VAULT_WRITE_GUARD_DIR` environment variable to your vault path. The script will exit with an error if this is not set.

### Agent instructions for vault operations

`CLAUDE.md` in the repo root contains agent-facing instructions: vault operation safety rules, self-healing patterns, the complete Obsidian CLI command reference, `obsidian eval` patterns for safe note editing, CLI gotchas, qmd semantic search syntax, and a "Which Tool When" decision matrix. Drop it into your vault's `.claude/` directory (or adapt for your agent's instruction format).

### MCP servers

See `config/mcp.json.example` for the three servers used:

| Server | Purpose | Install |
|---|---|---|
| `context7` | Current SDK/library documentation | `npx -y @upstash/context7-mcp` |
| `qmd` | Semantic search over your vault (BM25 + vector + LLM rerank). Use for concept/intent searches; use `obsidian search` for exact terms, tags, properties. See `CLAUDE.md` for query syntax and routing guidance. | `bun install -g @tobilu/qmd` ([github](https://github.com/tobi/qmd)). Or, you can just run it directly without installing: `bunx @tobilu/qmd`|

### Plugins

Recommended plugins for `~/.claude/settings.json` `enabledPlugins`:

| Plugin | Source | What it does |
|---|---|---|
| `superpowers` | [obra/superpowers-marketplace](https://github.com/obra/superpowers-marketplace) | Planning, git worktrees, parallel agents, TDD |
| `episodic-memory` | [obra/superpowers-marketplace](https://github.com/obra/superpowers-marketplace) | Search across all past agent conversations |
| `elements-of-style` | [obra/superpowers-marketplace](https://github.com/obra/superpowers-marketplace) | Writing quality rules |
| `sharp-edges` | [trailofbits/skills](https://github.com/trailofbits/skills) | Flags error-prone APIs and dangerous defaults |
| `ask-questions-if-underspecified` | [trailofbits/skills](https://github.com/trailofbits/skills) | Agent asks before assuming |
| `second-opinion` | [trailofbits/skills](https://github.com/trailofbits/skills) | External LLM code review |
| `last30days` | [mvanhorn/last30days-skill](https://github.com/mvanhorn/last30days-skill) | Threat intel from Reddit, X, HN, GitHub, Polymarket, web |
| `context7` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | SDK documentation lookup |
| `microsoft-docs` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Microsoft Learn search |
| `obsidian` | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) | Obsidian CLI, markdown, bases, canvas skills |
| `claude-md-management` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Audit and improve CLAUDE.md files |

## Skills

Skills are markdown files that teach the agent a specific workflow. Install by copying the directory to `~/.claude/skills/<name>/`.

### legislative-bill-analysis

Dual-lens bill analysis: general policy intent and CISO operational impact across eight domains. Dispatches a comparison agent to find similar legislation in other jurisdictions. Adapted to Connecticut's regulatory context but the domains apply to any state. Edit the .md file directly to replace your State & your neighboring States. 

How to use:
```
Analyze CT HB 6941 at https://cga.ct.gov/2026/TOB/H/PDF/2026HB-06941-R00-HB.PDF
```

Attribution: derived from [danielmiessler/fabric](https://github.com/danielmiessler/fabric) `analyze_bill` pattern (MIT license).

### humanizer

Built based on existing skill (repo below), I added the tropes.fyi as additional layer. 

Identifies and removes 50+ documented AI writing patterns. Based on [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) and the [tropes.fyi](https://tropes.fyi) taxonomy. Iterates until all AI tells are gone.


how to use:
```
/humanizer 
```

Then paste text, or point it at a file path.

### reflection

Reads your CLAUDE.md, settings, recent chat history, and proposes config improvements. Run quarterly as a self-audit. You could also use /insights built into Claude Code, both work really well. 

```
/reflection
```

### function-review

Code quality checklist: readability, cyclomatic complexity, data structures, naming, testability, hidden dependencies. Only recommends extraction when genuinely warranted.

### what-did-i-say

Searches your conversation history for past prompts. Clusters similar phrasings and analyzes how the agent interprets each variation.

```
/what-did-i-say create skill
```

### talk-panel-review

Simulated expert panel review of talk scripts and presentation drafts. Assembles 7-9 panelists (six fixed roles + adaptive specialists) who debate story arc, content credibility, audience fit, and delivery across three rounds -- then produce a ranked improvement list and a "do not change" protection list. Pulls recent industry context via `last30days` to evaluate whether the talk's framing is current. Works with any markdown talk script.

How to use:
```
Review my talk at Presentations/RSA 2026 Keynote.md
```

Or invoke directly:
```
/talk-panel-review
```

Recommended plugin: [last30days](https://github.com/mvanhorn/last30days-skill) for current industry context.

## Workflow templates

### Meeting dossier (`templates/prompt-meeting-dossier.md`)

This skill needs /last30days plugin (link at the bottom of this README).

Single prompt produces three vault artifacts:

- `People/<Org>/<Name>.md` -- contact profile with bio, focus areas, engagement guidance
- `Vendors/<Org>.md` -- vendor hub with relationship summary, contract links, discussion threads
- `Meetings/<Org>/<date>.md` -- scoped meeting note with empty Outcomes and Action Items sections

The agent runs parallel vault search (qmd) and web research, reads your current priorities, and assembles everything. 90 minutes of manual prep becomes 10 minutes of directed review.

```
Prep me for a meeting with CrowdStrike on 2026-05-01 at 14:00.
Attendees: Jane Smith (VP Sales, Public Sector), Tom Chen (SE).
Context: Annual renewal review, evaluate Falcon Next-Gen SIEM module.
```

**Rules that prevent common mistakes:**

- **Canonical facts live once.** Contract values, product specs, and bios belong in their canonical notes. Meeting notes reference via wikilink, never duplicate.
- **Meeting notes are time-scoped.** They capture context for one meeting, not running vendor state.
- **Bios live in People notes.** Meeting notes get a one-line engagement reminder per attendee, not a full bio.
- **Frontmatter discipline.** Meeting notes must have `type: meeting-note`, `vendor:`, `attendees:` (full names), and `time:` (HH:MM, 24-hour) for Dataview queries.
- **Outcomes + Action Items sections start empty.** They trigger post-meeting discipline -- fill within 24 hours.

### Committee update (`templates/prompt-committee-update.md`)

Two-phase prompt for monthly board/committee updates:

- **Phase 1:** Agent reads vault context, runs threat intel research, proposes 5 lede candidates. Stops and waits for your pick.
- **Phase 2:** You choose a lede. Agent drafts the full update on that axis, saves to your vault, and runs the humanizer.

The two-phase approach means you choose the angle in 30 seconds, then the AI drafts on the right axis.

### Diarized meeting minutes

End-to-end pipeline: phone recording to structured, speaker-attributed CISO minutes inside an Obsidian note. Everything runs locally -- no audio or transcript leaves your machine.

**Architecture:**

```
Phone recording (.m4a)
    |
    v
[Stage 1] WhisperX -- speech-to-text with speaker diarization
    |        Runs in a Python venv. Uses pyannote for speaker segmentation.
    |        Requires a HuggingFace token (pyannote model is gated).
    |        Output: plain text with [SPEAKER_00], [SPEAKER_01] labels.
    v
[Stage 2] Fabric + Ollama -- transcript to structured minutes
    |        Fabric CLI pipes the transcript through the ciso_minutes pattern.
    |        Ollama runs a local LLM (default: glm-5:cloud, configurable).
    |        The pattern's system prompt contains a rationalization reject table
    |        that prevents the LLM from fabricating decisions or consensus.
    |        Output: markdown minutes (Executive Summary, Key Statements,
    |        Decisions, Action Items, Risks/Issues, Open Questions).
    v
[Stage 3] Shell script + Templater glue
    |        obsidian_fabric_minutes.sh orchestrates stages 1-2 and appends
    |        both the raw transcript and structured minutes to the active note,
    |        wrapped in <!-- MINUTES-BLOCK --> comment markers.
    |        Also generates a Speakers mapping table.
    |        run_ciso_minutes.js bridges Obsidian's Electron runtime to the
    |        bash script (resolves note path, offers purge prompt, calls execFile).
    v
[Stage 4] Apply Speakers
             User edits the Speakers table (SPEAKER_00 -> "Jane Smith").
             Running the Apply Speakers template does a scoped find-and-replace
             within each MINUTES-BLOCK only -- the rest of the note is untouched.
```

**What gets appended to the note:**

```markdown
<!-- MINUTES-BLOCK:Recording_20260415 -->

## Speakers -- Recording_20260415

| ID | Name |
|----|------|
| SPEAKER_00 | SPEAKER_00 |
| SPEAKER_01 | SPEAKER_01 |

_Edit the Name column, then run the **Apply Speakers** template._

## Transcript -- Recording_20260415 (2026-04-15 16:41)

[SPEAKER_00] We need to talk about the SIEM migration timeline.
[SPEAKER_01] I think Q3 is realistic if we get funding approval by May.
...

## Minutes -- Recording_20260415

**Meeting Type:** decision meeting
**Speakers:** SPEAKER_00 = "unidentified", SPEAKER_01 = "unidentified"

**Executive Summary**
- SPEAKER_00 raised concerns about SIEM migration timeline...

**Decisions**
None stated.

**Action Items**
- SPEAKER_01 -- Send revised Q3 timeline to the team -- no due date stated
...

<!-- /MINUTES-BLOCK:Recording_20260415 -->
```

**The trust layer:**

`patterns/ciso_minutes/system.md` is the most important file in the pipeline. Without it, LLMs routinely fabricate decisions and commitments from ambient discussion. The pattern contains a rationalization reject table:

| LLM tendency | What actually happened | The pattern forces |
|---|---|---|
| "Everyone agreed" | People were silent | Name who explicitly agreed |
| "It was decided to..." | Someone floated an idea | Only report if someone said "let's do X" |
| "Action: [thing]" | Topic was mentioned | Only report if someone said "I will" or was assigned |
| "The team discussed concerns about..." | One person raised a concern | Attribute to the specific speaker |
| "This will be followed up on" | Nobody committed | Report as Open Question |
| "Based on the discussion, the next step is..." | The LLM is inferring | Only report next steps explicitly stated |

Every section in the output requires speaker attribution. Sections with no evidence say "None stated." A completeness check at the end verifies every speaker appears, every decision has an owner, and every claim traces to a specific statement.

#### Prerequisites

| Component | Purpose | Install |
|---|---|---|
| [WhisperX](https://github.com/m-bain/whisperX) | Speech-to-text + speaker diarization | Python venv (see below) |
| [Ollama](https://ollama.com) | Local LLM runtime | `brew install ollama` (macOS) |
| LLM model | Generates structured minutes | `ollama pull glm-5:cloud` (or `llama3.1:8b`) |
| [Fabric](https://github.com/danielmiessler/fabric) | Prompt pattern runner | `go install github.com/danielmiessler/fabric@latest` |
| HuggingFace token | Required for pyannote diarization model | [Create token](https://huggingface.co/settings/tokens), accept [pyannote license](https://huggingface.co/pyannote/speaker-diarization-3.1) |
| [Obsidian](https://obsidian.md) + [Templater](https://github.com/silentvoid13/Templater) | Vault integration | Community plugin |

#### Step-by-step setup

**1. Install WhisperX**

```bash
python3 -m venv ~/tools/whisperx-env
source ~/tools/whisperx-env/bin/activate
pip install whisperx
```

Create HuggingFace account, create and Save your HuggingFace token:

```bash
mkdir -p ~/.config/whisperx
echo "hf_YOUR_TOKEN_HERE" > ~/.config/whisperx/token
```

**2. Install Ollama and pull a model**

```bash
brew install ollama
ollama serve   # or it runs as a launchd service
ollama pull glm-5:cloud
```

Any capable model works, small one will be totally fine for this. The `OLLAMA_MODEL` env var overrides the default.

**3. Install Fabric and register the pattern**

```bash
go install github.com/danielmiessler/fabric@latest
fabric --setup
```

During setup, point Custom Patterns at your patterns directory. Then:

```bash
mkdir -p ~/.config/fabric/patterns/ciso_minutes
cp patterns/ciso_minutes/system.md ~/.config/fabric/patterns/ciso_minutes/
fabric -U
```

Verify: `fabric -l | grep ciso_minutes` should show the pattern.

**4. Install the shell script**

```bash
cp scripts/obsidian_fabric_minutes.sh ~/bin/
chmod +x ~/bin/obsidian_fabric_minutes.sh
```

Edit the CONFIG section at the top if your paths differ:

| Variable | Default | Change to |
|---|---|---|
| `WHISPERX_VENV` | `$HOME/tools/whisperx-env` | Your WhisperX venv path |
| `FABRIC_BIN` | `$HOME/go/bin/fabric` | Your fabric binary (run `which fabric`) |
| `OLLAMA_MODEL` | `glm-5:cloud` | Your preferred model |
| `WHISPERX_DEVICE` | `cpu` | `cuda` if you have an NVIDIA GPU |

**5. Run diagnostics**

```bash
~/bin/obsidian_fabric_minutes.sh -d
```

Checks: WhisperX binary exists and is executable, HuggingFace token file exists, Fabric CLI available, `ciso_minutes` pattern registered, Ollama reachable, model responds to test prompt. Every check reports PASS/FAIL/WARN.

**6. Install Templater scripts and templates**

```bash
# Scripts (Templater user scripts folder)
cp scripts/run_ciso_minutes.js <your-vault>/scripts/
cp scripts/apply_speakers.js <your-vault>/scripts/

# Templates
cp templates/tpl-ciso-minutes.md <your-vault>/Templates/
cp templates/apply-speakers.md <your-vault>/Templates/
```

The script reads the `CISO_MINUTES_HELPER` environment variable for the shell script path. If unset, it defaults to `$HOME/bin/obsidian_fabric_minutes.sh`. To override:

```bash
export CISO_MINUTES_HELPER="/your/custom/path/obsidian_fabric_minutes.sh"
```

**7. Configure Templater**

In Obsidian Settings > Templater:

- Set **User script functions folder** to your vault's `scripts/` directory
- Enable **Trigger Templater on new file creation** (optional)

#### How to use it

**Record and transfer:** Record a meeting audio in Obsidian's audio recorder tool, it captures the audio and automatically drops the file into your current open note (but saves it in vault's `Attachments/` or `Attachments/Audio/` folder). The script auto-detects the newest .m4a in those directories.

**Run the pipeline:**

1. Open the note you just recorded your voice memo in. 
2. Run Templater command palette: `Templater: Insert Template`
3. Select `tpl-ciso-minutes`
4. Templater prompts: keep or delete the raw transcript? Pick one.
5. Wait. WhisperX transcription takes roughly 1-2x the recording length on CPU, much faster on GPU (CUDA).
6. When done, the note has the Speakers table, raw transcript, and structured minutes appended.

**Rename speakers:**

1. Edit the Speakers table in the note:

```markdown
| ID | Name |
|----|------|
| SPEAKER_00 | Jane Smith |
| SPEAKER_01 | Alex Chen |
| SPEAKER_02 | SPEAKER_02 |
```

2. Run `Templater: Insert Template` > `apply-speakers`
3. Every `[SPEAKER_00]` and bare `SPEAKER_00` within that block becomes `[Jane Smith]` and `Jane Smith`. Only content between the `<!-- MINUTES-BLOCK -->` markers is touched.

**Hint speaker count** (improves diarization accuracy):

```bash
export WHISPERX_MIN_SPEAKERS=3
export WHISPERX_MAX_SPEAKERS=5
```

**Run without Templater (CLI only):**

```bash
~/bin/obsidian_fabric_minutes.sh \
  -a /path/to/recording.m4a \
  -n /absolute/path/to/meeting-note.md
```

Add `-k` to delete the transcript after insertion. Add `-A /path/to/attachments` to override audio search directory.

#### Environment variable reference

All configurable via shell environment. Defaults work for the standard install.

| Variable | Default | Purpose |
|---|---|---|
| `CISO_MINUTES_HELPER` | `$HOME/bin/obsidian_fabric_minutes.sh` | Path to the shell script (used by `run_ciso_minutes.js`) |
| `VAULT_WRITE_GUARD_DIR` | (required) | Vault path for the write-guard hook |
| `WHISPERX_VENV` | `$HOME/tools/whisperx-env` | WhisperX Python venv path |
| `WHISPERX_BIN` | `$WHISPERX_VENV/bin/whisperx` | WhisperX binary |
| `HF_TOKEN_FILE` | `$HOME/.config/whisperx/token` | HuggingFace token for pyannote |
| `WHISPERX_DEVICE` | `cpu` | `cpu` or `cuda` |
| `WHISPERX_COMPUTE` | `int8` | Compute type for WhisperX |
| `WHISPERX_MODEL` | `small` | Whisper model size |
| `WHISPERX_MIN_SPEAKERS` | (unset) | Hint for pyannote min speaker count |
| `WHISPERX_MAX_SPEAKERS` | (unset) | Hint for pyannote max speaker count |
| `FABRIC_BIN` | `$HOME/go/bin/fabric` | Fabric CLI binary |
| `FABRIC_PATTERN` | `ciso_minutes` | Fabric pattern name |
| `PATTERN_DIR` | `$HOME/.config/fabric/patterns` | Custom patterns directory |
| `OLLAMA_URL` | `http://localhost:11434` | Ollama API endpoint |
| `OLLAMA_MODEL` | `glm-5:cloud` | LLM model for minutes generation |

#### File inventory

| File | Role | Install to |
|---|---|---|
| `scripts/obsidian_fabric_minutes.sh` | Orchestrator: WhisperX + Fabric + note insertion | `~/bin/` (or anywhere on PATH) |
| `scripts/run_ciso_minutes.js` | Templater glue: resolves note path, calls the shell script | `<vault>/scripts/` |
| `scripts/apply_speakers.js` | Scoped find-and-replace: SPEAKER_XX to real names | `<vault>/scripts/` |
| `patterns/ciso_minutes/system.md` | LLM system prompt with rationalization reject rules | `~/.config/fabric/patterns/ciso_minutes/` |
| `templates/tpl-ciso-minutes.md` | Templater trigger for the minutes pipeline | `<vault>/Templates/` |
| `templates/apply-speakers.md` | Templater trigger for speaker rename | `<vault>/Templates/` |

## Vault maintenance

Weekly cycle (10-15 minutes):

1. **Surface inconsistencies.** Ask the agent to audit `Projects/`, `Reference/`, and `Vendors/` for mismatched status frontmatter, stale dates, broken wikilinks, and duplicated facts.
2. **Review and fix.** Walk through findings. Agent applies changes one note at a time.
3. **Check vault health.** Run `obsidian unresolved counts`, `obsidian orphans`, `obsidian deadends`.
4. **Re-index semantic search.** Just run `bunx @tobilu/qmd update && bunx @tobilu/qmd embed -f && qbunx @tobilu/qmd status` and qmd will re-index and re-vectorize all your markdown files in your vault. 
5. **Spot-check.** Run semantic queries on topics you just updated.

## Anti-patterns

- **Every plugin enabled.** Plugin sprawl burns context window and confuses the agent. Pick the ones that match your role.
- **Writes to authoritative files without integrity hooks.** The vault write-guard is load-bearing.
- **AI-generated text to legislators or boards without a humanizer pass.** AI tells are recognizable.
- **Credentials in agent-readable locations.** AWS, SSH, Azure CLI tokens belong on the deny list.
- **Agent self-assessment as the done-check.** The Stop hook LLM judge exists because agents claim completion when work is incomplete.
- **AI on a chaotic vault.** Without vault discipline the AI hallucinates against your own knowledge base.

## Adapting to other agents

Most artifacts here are agent-agnostic markdown. The Claude Code-specific parts:

| Claude Code concept | Equivalent elsewhere |
|---|---|
| `CLAUDE.md` | `AGENTS.md` (OpenAI Codex), system prompt (Cursor), workspace instructions |
| `~/.claude/settings.json` | Agent-specific config file |
| Skills (`SKILL.md`) | Custom instructions, system prompts, or tool definitions |
| Hooks (PreToolUse, PostToolUse, Stop) | Pre/post execution hooks, guardrails, or middleware |
| MCP servers | Tool/plugin integrations native to your agent |
| `enabledPlugins` | Plugin/extension marketplace for your agent |

The vault structure, templates, Fabric patterns, and the WhisperX pipeline work with any agent that can read files and run shell commands.

### Windows users

This repo was built on macOS. The vault itself (markdown files, templates, skills) is fully cross-platform. The tooling layer assumes a Unix shell.

**Recommended path: WSL2.**

Install [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) with Ubuntu. Run Claude Code, the hooks, WhisperX, Fabric, and Ollama inside WSL.

```powershell
wsl --install -d Ubuntu
```

**What works in WSL without changes:**

- All shell scripts and hooks (bash, jq, grep, wc -- native Linux)
- Claude Code + all three hooks (deny, audit log, Stop judge)
- vault-write-guard.sh
- WhisperX and Fabric (better GPU support than macOS via CUDA passthrough)
- Ollama
- qmd MCP server
- All skills (markdown files)
- Your vault files at `/mnt/c/Users/<you>/...` (Windows filesystem mounted in WSL)

**What breaks on WSL and needs workarounds:**

| Problem | Why it breaks | Workaround |
|---|---|---|
| **Obsidian CLI** | The CLI is baked into the Obsidian desktop binary and talks to the running app via IPC. If Obsidian runs as a Windows desktop app and the agent runs inside WSL, the IPC channel does not connect. This breaks every `obsidian read`, `obsidian search`, `obsidian eval`, `obsidian create` command -- which the CLAUDE.md, templates, and workflows all depend on. | **Option A:** Run Obsidian inside WSL via [WSLg](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps) (graphical Linux apps on Windows). IPC works natively. **Option B:** Skip the Obsidian CLI entirely. Have the agent read/write markdown files directly using built-in file tools. You lose Obsidian version history integration and the iCloud sync safety layer, but the vault content is identical. |
| **Templater -> shell script bridge** | `run_ciso_minutes.js` runs inside Obsidian's Electron runtime (Windows-side) and calls `obsidian_fabric_minutes.sh` via `execFile`. If the bash script lives in WSL, that call fails. | Prefix with `wsl bash /path/to/script.sh` in the helper path, or install the pipeline tools (WhisperX, Fabric, Ollama) on the Windows side too. |
| **iCloud sync** | Not available on Windows. | Use OneDrive, [Syncthing](https://syncthing.net/), or [Obsidian Sync](https://obsidian.md/sync) instead. Point the vault at a synced folder that both Obsidian and WSL can reach. |

**Without WSL:** The alternative is rewriting every shell script and hook in PowerShell. The vault, skills, and templates work natively on Windows -- only the bash tooling layer needs porting. That is doable but more work than installing WSL for no functional gain.

## Personalization checklist

After cloning, search-and-replace these placeholders to match your environment:

| Placeholder / Setting | Where | What to do |
|---|---|---|
| `[YOUR_NAME]` | `templates/prompt-committee-update.md` | Your name |
| `[YOUR_TITLE]` | `templates/prompt-committee-update.md` | Your title (e.g. "CISO") |
| `[YOUR_ORGANIZATION]` | `templates/prompt-committee-update.md` | Your organization |
| `<YOUR_PROJECT_DIR>` | `skills/what-did-i-say/TASK.md` | Your Claude Code project directory (run `ls ~/.claude/projects/` to find it) |
| `VAULT_WRITE_GUARD_DIR` | Environment or shell profile | Absolute path to your Obsidian vault (required for the write-guard hook) |
| `CISO_MINUTES_HELPER` | Environment or shell profile | Path to `obsidian_fabric_minutes.sh` if not at `$HOME/bin/` |
| State legislature URL | `skills/legislative-bill-analysis/SKILL.md` | Replace the example `cga.ct.gov` with your state's legislature site |
| Comparator jurisdictions | `skills/legislative-bill-analysis/SKILL.md` | Replace example neighboring states with yours |
| `<YourOrg>` vault paths | `templates/prompt-committee-update.md`, `templates/prompt-meeting-dossier.md`, `templates/tpl-meeting-note.md` | Replace with your top-level vault folder name |
| `OLLAMA_MODEL` | Environment (optional) | Override if you use a different model than `glm-5:cloud` |

Scripts use `$HOME`-relative defaults where possible, so if you follow the standard install paths (`~/bin/`, `~/tools/whisperx-env/`, `~/go/bin/fabric`), most settings work without changes.

## Provenance

Nothing here is original except glue code and CISO domain adaptations. Full credit:

| Component | Source |
|---|---|
| Hardening pattern (deny list, hooks) | [Trail of Bits Claude Code config](https://github.com/trailofbits/claude-code-config) |
| Humanizer skill | [blader/humanizer](https://github.com/blader/humanizer), based on [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) and [tropes.fyi](https://tropes.fyi) |
| Legislative bill analysis | Derived from [danielmiessler/fabric](https://github.com/danielmiessler/fabric) `analyze_bill` pattern (MIT) |
| Minutes pipeline | [WhisperX](https://github.com/m-bain/whisperX), [Ollama](https://ollama.com), [Fabric](https://github.com/danielmiessler/fabric), [Templater](https://github.com/silentvoid13/Templater) |
| Plugins | [Trail of Bits skills](https://github.com/trailofbits/skills), [obra/superpowers](https://github.com/obra/superpowers-marketplace), [Anthropic plugins](https://github.com/anthropics/claude-plugins-official), [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills), [mvanhorn/last30days](https://github.com/mvanhorn/last30days-skill) |
| Obsidian CLI | [Obsidian](https://obsidian.md) |
| Semantic search | [qmd](https://github.com/tobi/qmd) by Tobi Lutke |

## License

MIT. See individual skill directories for upstream license terms where applicable.

## Contact

Gene Meltser -- gene.meltser@ct.gov

Open an issue on this repo, or email for questions about configuration details.
