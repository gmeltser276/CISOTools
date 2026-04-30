---
created: 2026-04-24
type: template
tags:
  - committee
  - template
---

# Monthly Statewide Cybersecurity Committee — Update Template

Reusable two-phase prompt for building the monthly CISO update.
Update `MEETING_DATE` each month. Everything else stays stable.

---

## Phase 1 — Research + lede candidates

```
MEETING_DATE: YYYY-MM-DD
CADENCE: Last Monday of every month
AUDIENCE: State agency liaisons + CSMs, utilities/critical infrastructure, CTIC, DEHMS, CEN, private industry, casinos, tribal nations, towns, municipalities

You are preparing a CISO update for Gene Meltser, CISO for State of Connecticut, for the Monthly Statewide Cybersecurity Committee on [MEETING_DATE].

Step 1 — Read the scaffold and last month's update
- 00. StateOfCT/Presentations/Monthly CyberSecurity Committee/Process.md
- 00. StateOfCT/Presentations/Monthly CyberSecurity Committee/ [most recent prior month file]
Do NOT repeat topics from last month unless there are material new developments after the 1st of this month.

Step 2 — Read current vault state
- 00. StateOfCT/Wins.md
- 00. StateOfCT/1-1s/Mark Raymond.md
- 00. StateOfCT/Reference/2026 Current Priorities.md
- Relevant notes from 00. StateOfCT/10. Projects/
- Content from my Home.md file
- Obsidian Vault files updated in the last month

Step 3 — External research
Run /last30days with ' --deep' command line option on: "state government cybersecurity threat intelligence update [Month Year]"

Then run targeted Exa searches on:
- Major incidents last 30 days affecting enterprise or government, especially State Level government
- CISA posture updates since last month
- Nation-state threat activity (OT/ICS, destructive ops). Focus specifially on SLTT, State of CT. 
- AI and agentic security developments
- Federal policy changes with state government , or upcoming changes
  
Step 5 - Validation
- Always run validation of claims and data on each topic. confirm with confidence that our information gathered is factual.
- Always provide sources
- Check if its acccurate via sources then fix any that are found to be inaccurate. Repeat this step until no inaccuracies found. 
- Check for relevantce. Is eaach item relevant to us in State of CT, for State, locals, etc? If not relevant, remove. 

Exclusions — do not surface:
- Topics covered last month unless material new developments
- Vendor commercial details, in-flight RFPs, in-flight personnel decisions
- Anything tagged #confidential or in 00. StateOfCT/98. Archive/
- Check for relevance: is it relevant to attendees in this meeting? If not, remove.

Step 6 — Propose exactly 5 lede candidates
For each:
- Headline: 1-2 punchy professional sentences (short, specific, names the stakes)
- Why this lede: relevance to this room, this month
- CT angle: what CT can say or do about it
- Audience hook: which stakeholder group it most directly concerns

STOP after presenting the 5 candidates. Wait for Gene to choose before drafting anything.
```

---

## Phase 2 — Full draft

Paste after picking a lede from Phase 1.

```
MEETING_DATE: YYYY-MM-DD
CHOSEN_LEDE: [paste the lede you picked from Phase 1]

Build the [Month Year] CISO update per Process.md. Use the chosen lede to anchor the threat landscape section.

Sections:
1. Threat landscape — 4-5 items, external focus, punchy. Chosen lede goes first.
2. CT wins — table format, factual, from Wins.md and recent project notes
3. Active initiatives — table format, next step only, from 10. Projects/
4. Ask by audience — one subsection per group (state agencies/CSMs, utilities/critical
   infrastructure, CTIC, DEHMS, CEN, private industry, casinos/tribal nations, towns).
   Directives, not suggestions.
5. What we're watching — 3-4 items, forward-looking. 

Speaking notes:
After each section heading, add a blockquote:
> Speaking note: [1-2 sentences Gene can say verbally to open the section]
Not a script. A verbal anchor.

Save output to:
00. StateOfCT/Presentations/Monthly CyberSecurity Committee/YYYY-MM Month.md

Frontmatter: type: presentation, tags: [committee, ciso-update, cybersecurity], created: [today]

Then run /humanizer on the saved file path.
```