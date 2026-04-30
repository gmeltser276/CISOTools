---
description: Produce a comprehensive meeting dossier for a scheduled meeting with external contacts
---

# Meeting Dossier Prompt

Use this prompt when asked to prep for a meeting. It produces a scoped meeting note under `<YourOrg>/Meetings/<Organization>/<YYYY-MM-DD> <attendees>.md`, creates or reuses People profiles under `<YourOrg>/People/<Organization>/`, and a vendor hub note at `<YourOrg>/Vendors/<Organization>.md`. Canonical facts are never duplicated across the vault.

## Required Inputs

Extract from the user at the start:

- **Organization** (vendor or partner)
- **Attendees** (full name, role if given)
- **Meeting date** (YYYY-MM-DD)
- **Meeting time** (HH:MM, 24-hour) — **if not provided, ask the user once before proceeding**
- **Meeting format** (in-person / virtual / phone; location if in-person)
- **Meeting context** (regular cadence, first intro, panel follow-up, contract review, etc.)

If multiple inputs are missing, batch them into a single clarifying question. Do not ask iteratively.

## Research Plan (run in parallel)

1. **Vault — existing relationship context**
   - `mcp__qmd__query` with lex+vec searches for the organization name, any known products, any prior meeting terms
   - `obsidian search query="<Organization>"` for exact matches
   - Check `<YourOrg>/Vendors/<Organization>.md` for a vendor hub note. If missing, flag to create it
   - Check `<YourOrg>/People/<Organization>/<Name>.md` for each attendee. If missing, flag to create it
   - Read current priorities: `<YourOrg>/Reference/2026 Current Priorities.md`
   - Search for other priorities, ongoing projects, initiatives, efforts or implemenrations

2. **Vault — prior meetings with same org/people**
   - List `<YourOrg>/Meetings/<Organization>/` if it exists
   - Scan recent notes for action items carried forward

3. **Web — external research (background Agent)**
   - Spawn a background `Agent` (subagent_type: general-purpose) to search for:
     - Each attendee's current role, tenure, public speaking, published work
     - Organization's current offerings relevant to CT (state gov + higher ed where applicable)
     - Recent announcements, partnerships, or CT-specific engagements in the last 12 months
   - Use `mcp__exa__web_search_exa` exclusively (never built-in WebSearch)
   - Agent returns factual summary only; flag what cannot be found

## Outputs (in this order)

### 1. People profile notes — `<YourOrg>/People/<Organization>/<Name>.md`

Create one per attendee if not already present. Structure:

```markdown
---
created: <today>
updated: <today>
type: person-profile
status: active
tags: [person, <org-slug>, external]
org: <Organization>
role: <current role>
location: <if known>
linkedin: <if known>
---

# <Name>

One-line current role summary.

## Background
Chronological summary: prior roles, education, certifications, affiliations.

## Focus Areas
Bulleted list of their subject-matter focus.

## Public Posture
What they say publicly. Themes they consistently push. Named talks/articles with links.

## How to Engage
Tactical guidance for the user: what register to use, what lands, what to avoid.

## Meetings
Dataview query listing all meetings where this person appears in attendees frontmatter, scoped to `FROM "<YourOrg>/Meetings"`.

## Related
Links to vendor hub, contract notes, relevant project notes.
```

### 2. Vendor hub note — `<YourOrg>/Vendors/<Organization>.md`

Create if missing; update if present. Single entry point for the relationship. Must not duplicate contract line items (those live in the contract reference note). Must include:

- Relationship summary (one paragraph)
- Products & Services In Use (table, each row links to canonical note)
- Products Under Evaluation or Available
- Contacts: organization contacts (link to People notes via `[[<Name>]]`), CT internal owners, integration partners
- Contract Snapshot (one-line, link to contract reference note)
- Adjacent <YourOrg>-<Organization> footprint (engagements outside your team's lane, if any)
- Active Discussion Threads (open asks across all meetings)
- Dataview query listing all meetings `FROM "<YourOrg>/Meetings/<Organization>"`
- Related notes

### 3. Meeting note — `<YourOrg>/Meetings/<Organization>/<YYYY-MM-DD> <attendee-lastnames>.md`

Scoped to this single meeting. Must begin with a callout linking to the vendor hub and canonical contract note, stating facts live there. Frontmatter must include:

```yaml
---
created: <today>
updated: <today>
time: "HH:MM"   # 24-hour. Ask user if unknown. Never leave blank silently.
type: meeting-note
status: active
tags: [meeting, <org-slug>]
vendor: <Organization>
attendees:
  - <Full Name>   # full names for Dataview contains() queries
  - ...
---
```

Body must include:

- Header block: date, time, format, context
- Who Is In The Room: each attendee as `[[Wikilink]]` + one-line engagement reminder (not a bio)
- What CT Brings: bullets referencing canonical notes, not duplicating them
- Discussion Topics: Priority Asks table + numbered sections per topic
- What They Want
- Outcomes (empty placeholder, to fill within 24 hours)
- Action Items (empty, Obsidian Tasks syntax)
- Follow-Up Meetings

## Rules

- **Never duplicate canonical facts.** Contract values, product specs, and contact biographies live in their canonical notes. Meeting notes reference via wikilink.
- **Never add a bio to the meeting note.** One-line engagement reminders only. Full bios live in People notes.
- **Frontmatter `attendees` uses full names** for Dataview `contains()` queries.
- **Meeting `time:` is required.** If user did not specify, ask once; do not invent or leave blank.
- **Empty Outcomes and Action Items sections are required.** They trigger post-meeting discipline.
- **Use Obsidian CLI for all `.md` writes.** Not built-in Write/Edit. See vault CLAUDE.md.
- **Produce the dossier as vault notes, not terminal output.** User reads them in Obsidian. Confirm paths at the end.
- **Flag uncertain web-research findings.** Say "not found" rather than speculate. Link sources where possible.

## Quick Start

When the user says "prep me for a meeting with X at Y":

1. Extract org, attendees, date, time, context. Ask at most one batched clarifying question if inputs are missing.
2. Kick off parallel research (vault qmd + web agent in background).
3. Read canonical vendor hub and contract notes.
4. Build People profiles → vendor hub → meeting note in that order.
5. Return paths and headline recommendations for the discussion. Not the full note body.